class SkuLoc < LedgerBuddyModel

    attr_accessor :id, :sku_id, :loction_id

    belongs_to :sku
    belongs_to :location

end
