class User < MotionResource::Base
    attr_accessor :username, :token, :email

    cattr_accessor :current

    self.member_url = "users/:id"

    def gravatar_url(options = {})
        hash = NSData.MD5HexDigest(email.strip.downcase.dataUsingEncoding(NSUTF8StringEncoding))
        "http://www.gravatar.com/avatar/#{hash}.png?s=#{options[:size] || 40}"
    end
end
