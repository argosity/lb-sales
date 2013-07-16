class Invoice < LedgerBuddyModel

    attribute :visible_id, :customer_id, :location_id, :state

#    attribute :lines_attributes

    attr_accessor :list
    attr_accessor :total

    belongs_to :bill_addr, :class_name=>'Address'
    belongs_to :ship_addr, :class_name=>'Address'

    self.collection_url = "invoices"
    self.member_url     = "invoices/:id"

    def self.tax_rate
        ( rate = NSUserDefaults.standardUserDefaults.stringForKey("tax_rate") ) ? rate.to_f : 0.0
    end

    has_many :lines, :class_name=>'InvLine', :params=>lambda{ |inv| {
            :invoice_id => inv.id,
            :include=> [:sku_loc,{:sku=>[:images]}]
        }
    }

    def initialize( attributes={} )
        self.total = 0.0
        if self.new_record?
            Location.default do | location |
                self.location_id = location.id
            end
            Customer.default do | customer |
                self.customer_id = customer.id
            end
        end

        super
    end

    def tax_line
        @tax ||= Sku.tax
        self.lines.select{ |l| @tax.code == l.sku.code }.first
    end

    def regular_lines
        self.lines - [ tax_line ]
    end

    def loadAll( &block )
        self.lines do | lines |
            block.call( self )
        end
    end

    def addSku( sku )
        if line = lines.detect{ | l | l.sku.code == sku.code }
            line.qty += 1
        else
            line = InvLine.new({ invoice_id: self.id, qty: 1 })
            line.invoice = self
            line.sku = sku
            @lines << line
        end
        self.updateTotal
        line
    end


    def updateTotal
        return unless @lines
        tax_amount = ( regular_lines.sum(&:total).round(2) * Invoice.tax_rate ).round(2)
        tax = tax_line
        if tax_amount > 0
            tax = addSku( Sku.tax ) unless tax
            tax.price = tax_amount
        else
            @lines.remove( tax ) if tax
        end
        self.total = @lines.sum(&:total).round(2)
    end

    # def attributes
    #     attrs = super
    #     attrs.merge({
    #             :lines_attributes => self.lines.map{|l|l.attributes }
    #         })
    #     p attrs
    #     attrs.delete(:lines)
    #     attrs
    # end

end
