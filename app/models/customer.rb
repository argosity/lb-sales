class Customer < LedgerBuddyModel


    self.collection_url = "customers"
    self.member_url = "customers/:id"

    def self.default_code
        ( code = NSUserDefaults.standardUserDefaults.stringForKey("customer_code") ) ? code.upcase : nil
    end

    def self.default(&block)
        return unless self.default_code
        if @default
            block.call( @default ) if block
            return @default
        else
            self.find_all({ query: {code: self.default_code } }) do | customers, resp |
                unless customers.empty?
                    @default = customers.first
                    block.call( @default ) if block
                end
            end
        end
    end

end
