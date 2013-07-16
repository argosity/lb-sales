class Image < LedgerBuddyModel

    attr_accessor :id, :dimensions, :file

    def medium
        file['medium']
    end

    def large
        file['large']
    end

    def thumb
        file['thumb']
    end

end
