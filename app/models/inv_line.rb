class InvLine < LedgerBuddyModel

    attribute :sku_loc_id, :invoice_id
    attribute :sku_id, :qty, :uom_code, :uom_size, :price, :sku_code, :description

    belongs_to :sku
    belongs_to :sku_loc

    attr_accessor :invoice

    self.collection_url     = "invoices/:invoice_id/lines"
    self.member_url     = "invoices/:invoice_id/lines"

    def adjQty( change )
        self.qty += change
        self.invoice.updateTotal
    end

    def total
        ( self.price.to_f * self.qty.to_i ).round(2)
    end

    def sku=(sku)
        unless sku.is_a?(Sku)
            sku = Sku.instantiate(sku)
        end
        loc = Location.default
        self.sku_loc     = sku.locations.detect{|sl| sl.sku_id == sku.id } if sku.locations
        self.sku_loc_id  = self.sku_loc.id if self.sku_loc
        self.sku_code    = sku.code
        self.description = sku.description
        if sku.default_uom
            self.uom_size   = sku.default_uom.size
            self.uom_code   = sku.default_uom.code
            self.price      = sku.default_uom.base_price
        end
        @sku=sku
    end


end
