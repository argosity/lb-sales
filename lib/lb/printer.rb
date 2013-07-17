module LB

    class Printer

        attr_reader :name

        def self.selected=(printer)
            @selected = printer
            prefs = NSUserDefaults.standardUserDefaults
            prefs.setObject( printer.name, forKey:"selected_printer" )
            prefs.synchronize
        end

        def self.selected
            return @selected if @selected
            name = NSUserDefaults.standardUserDefaults.stringForKey("selected_printer")
            name ? @selected=Printer.new( name ) : nil
        end

        def self.server
            NSUserDefaults.standardUserDefaults.stringForKey("printer_address")
        end

        def self.available( &block )
            url = Printer.server + '/printers'
            unless url=~/^http/
                url = 'http://' + url
            end
            BubbleWrap::HTTP.send( :get, url, {} ) do |response|
                printers = if response.ok?
                               BubbleWrap::JSON.parse(response.body ).map{|json| Printer.new( json['name'] ) }
                           else
                               []
                           end
                block.call( printers , response )
            end
        end

        def initialize( name )
            @name = name
        end


        def is_selected?
            Printer.selected && Printer.selected.name == self.name
        end

        def print( invoice )
            invoice
        end

    end

end
