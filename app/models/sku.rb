class Sku < LedgerBuddyModel

    attr_accessor :id, :bin, :code, :default_uom_code, :default_vendor_id
    attr_accessor :is_other_charge, :can_backorder, :is_discontinued, :default_uom_code
    attr_accessor :description, :does_track_inventory, :gl_asset_account_id, :gl_revenue_account_id

    self.collection_url = "skus"
    self.member_url = "skus/:id"

    has_many :images
    has_many :items, {
        :params=>lambda { |sku| { include:['images'],scope: { with_sku_id: sku.id }} }
    }
    has_many :locations, :class_name=>'SkuLoc'
    has_many :uoms, :class_name=>'UOM'


    def self.tax(&block)
        if @tax
            block.call( @tax ) if block
            return @tax
        else
            self.find('tax',{ :include => ['locations','uoms'] }) do | sku, resp |
                @tax = sku
                block.call( @tax ) if block
            end
        end
    end

    def default_uom
        @default_uom ||= self.uoms.detect{ |uom| uom.code == self.default_uom_code }
    end

    def thumbnail_url
        images.empty? ? nil : "http://web.ledgerbuddy.dev#{images.first.thumb.url}"
    end

end
