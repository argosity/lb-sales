class InvoiceList < Array

    def initialize
        @size = 0
    end

    def total_size
        @size
    end

    def prepend( invoice )
        invoice.list = self
        unshift( invoice )
        invoice
    end

    def load_page( pg, &block )
        start = pg*100
        if start > @size
            block.call self
            return
        end
        Invoice.find_all({
                :limit     => 100,
                :start     => start,
                :sort      => {:created_at=>'desc'},
                :include   => ['bill_addr'],
                :optfields => ['total']
            }) do | invoices, resp |
            @size = resp.body['total']
            if resp.ok?
                invoices.each{ |i| i.list=self }
                self.concat( invoices )
                block.call self
            end
        end
    end

end
