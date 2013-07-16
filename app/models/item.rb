class Item < LedgerBuddyModel

    attr_accessor :id, :title, :tags, :is_discontinued, :description, :extended_description

    self.collection_url = 'items'

    has_many :images

end
