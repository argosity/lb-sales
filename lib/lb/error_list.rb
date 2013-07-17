module LB
    class ErrorList
        include Enumerable

        def initialize
            @errors = Hash.new {|hash, key| hash[key] = Array.new }
        end

        def clear
            @errors.clear
        end

        def empty?
            @errors.empty?
        end

        def any?
            ! self.empty?
        end

        def each
            @errors.each{| attr, msg | yield full_message_for(attr) }
        end

        def add( attribute, message )
            msgs = @errors[ attribute ]
            msgs.push( message ) unless msgs.include?( message )
            self
        end

        def full_message_for( attribute )
            if :base == attribute
                @errors[ attribute ]
            elsif @errors.has_key?( attribute )
                attribute.to_s.tr('.', '_').humanize + ' ' + @errors[ attribute ].join( '; ')
            else
                nil
            end
        end

        def full_messages
            self.to_a
        end
    end


end
