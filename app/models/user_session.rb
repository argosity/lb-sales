class UserSession < LedgerBuddyModel

    attribute :id, :username, :email, :password

    self.collection_url = "users"

    def get_token(&block)

        self.class.post( 'tokens', :payload => attributes ) do | resp, json |
            if resp.ok?
                MotionResource::Base.default_url_options = {
                    :present_credentials => true,
                    :credentials => { :username => json["token"], :password=>'X' }
                }
                User.current = User.new( json )
            end
            block.call( resp, json)
        end

    end

end
