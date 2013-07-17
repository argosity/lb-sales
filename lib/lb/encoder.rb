module LB

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

end
