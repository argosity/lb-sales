class LedgerBuddyModel < MotionResource::Base

    # def save(&block)
    #   run_callbacks :save do
    #     @new_record ? create(&block) : update(&block)
    #   end
    # end

    # def update(&block)
    #   run_callbacks :update do
    #     self.class.put(member_url, :payload => { :data => attributes }) do |response, json|
    #       self.class.request_block_call(block, json.blank? ? self : self.class.instantiate(json), response) if block
    #     end
    #   end
    # end

    # def create(&block)
    #   # weird heisenbug: Specs crash without that line :(
    #   dummy = self
    #   run_callbacks :create do
    #     self.class.post(collection_url, :payload => { :data => attributes }) do |response, json|
    #       self.class.request_block_call(block, json.blank? ? self : self.class.instantiate(json), response) if block
    #     end
    #   end
    # end

    # def self.create(attributes = {}, &block)
    #   new(attributes).tap do |model|
    #     model.create(&block)
    #   end
    # end

    # def destroy(&block)
    #   run_callbacks :destroy do
    #     self.class.delete(member_url) do |response, json|
    #       self.class.request_block_call(block, json.blank? ? nil : self.class.instantiate(json), response) if block
    #     end
    #   end
    # end

    # def reload(&block)
    #   self.class.get(member_url) do |response, json|
    #     self.class.request_block_call(block, json.blank? ? nil : self.class.instantiate(json), response) if block
    #   end
    # end

    class Encoder < MotionResource::UrlEncoder

        def build_query_string(url, params = {})
            return url if params.keys.empty?
            # fake a url so we avoid regex nastiness with URL's
            url = NSURL.URLWithString("http://blah.com/#{url}")
            # build our query string (needs encoding support!)
            query_string = CGI.unescape( params.to_query )
            if url.query.nil? || url.query.empty?
                # strip the beginning / and add the query
                "#{url.path[1..-1]}?#{query_string}"
            else
                "#{url.path[1..-1]}?#{url.query}&#{query_string}"
            end
        end

        def insert_extension(url,extension)
            return url if extension.blank?
            url, params = url.split('?')
            url << extension
            if params
                url + '?' + params
            else
                url
            end
        end

    end

    self.url_encoder = Encoder.new

    attr_accessor :updated_at, :updated_by_id
    attr_accessor :created_at, :created_by_id

    # def initialize( attributes={} )
    #     super
    #     @updated_at ||= Time.now
    #     @created_at ||= Time.now
    #     self
    # end


    def updated_at=(val)
        @updated_at = val.is_a?(String) ? Time.iso8601(val) : val
    end
    def created_at=(val)
        @created_at = val.is_a?(String) ? Time.iso8601(val) : val
    end

    def self.json_root
        'data'
    end

    def self.query_by( hash, &block )
        self.find_all({ 'query'=> hash } ) do | records, resp |
            block.call( records, resp )
        end
    end

    def last_api_message
        @last_api_message
    end

    def build_payload(options)
        data = super
        { 'data' => data[ self.class.name.underscore ] }
    end

    def self.decode_response( response, url, options )
        json = super
        if json
            response.instance_variable_set("@body", json )
            @last_api_message = json['message']
            if false == json['success']
                response.status_code='500'
                if json['message']
                    SVProgressHUD.showErrorWithStatus( json['message'] )
                    response.error_message = json['message']
                end
                return nil
            end
            data = json['data'] ? json['data'] : json
            if data.is_a?(Array)
                return data.map{|el| Hashie::Mash.new( el ) }
            else
                return Hashie::Mash.new( data )
            end
        end
        Hashie::Mash.new
    end

end
