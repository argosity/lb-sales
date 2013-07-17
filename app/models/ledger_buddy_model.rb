class LedgerBuddyModel < MotionResource::Base

    self.url_encoder = LB::Encoder.new
    def self.json_root
        'data'
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


    attr_accessor :updated_at, :updated_by_id
    attr_accessor :created_at, :created_by_id
    attr_accessor :errors

    after_create  :clear_errors
    after_save    :clear_errors
    after_update  :clear_errors
    after_destroy :clear_errors

    def updated_at=(val)
        @updated_at = val.is_a?(String) ? Time.iso8601(val) : val
    end
    def created_at=(val)
        @created_at = val.is_a?(String) ? Time.iso8601(val) : val
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

    def valid?
        self.errors.empty?
    end

    def errors
        @errors ||= LB::ErrorList.new
    end

    def clear_errors
        self.errors.clear
    end
end
