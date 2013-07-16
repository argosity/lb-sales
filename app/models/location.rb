class Location < LedgerBuddyModel


    self.collection_url = "locations"
    self.member_url = "locations/:id"

    def self.default_code
        ( code = NSUserDefaults.standardUserDefaults.stringForKey("location_code") ) ? code.upcase : nil
    end


    def self.default(&block)
        return unless self.default_code
        if @default
            block.call( @default ) if block
            return @default
        else
            self.find_all({ query: {code: default_code } }) do | locations, resp |
                unless locations.empty?
                    @default = locations.first
                    block.call( @default ) if block
                end
            end
        end
    end

end
