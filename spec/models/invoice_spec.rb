describe Invoice do

    extend LB::SpecHelper

    it "should load page" do
#       Sku.logger = Invoice.logger = MotionSupport::StdoutLogger.new
        url = spec_url('invoices',{
                           :include=>[ :bill_addr ],
                           :limit=>100,
                           :optfields=>[:total],
                           :sort=>{:created_at=>'desc'},
                           :start=>0
                   } )
        stub_request(:get, url)
            .to_return( json: { total: 200, data: [
                                      { id: 1, visible_id: 23 },
                                      { id: 2, visible_id: 24 }
                                     ] } )
        @invoices = InvoiceList.new
        @invoices.load_page(0) do
            resume
        end

        wait_max 1.0 do
            @invoices.total_size.should.equal 200
            @invoices.first.visible_id.should.equal 23
        end

    end

    it "should validate" do
        invoice = Invoice.new
        invoice.location_id = nil
        invoice.valid?.should.equal false
        invoice.errors.full_message_for(:location).should.equal "Location can't be blank"
    end

    it "can be created" do
#       Sku.logger = Invoice.logger = MotionSupport::StdoutLogger.new
        url = spec_url('invoices',{})

        stub_request(:post, url)
            .to_return( json: { data: {
                                :id=>22, :visible_id=>33
                            } } )
        @invoice = Invoice.new
        @invoice.addSku( test_sku )

        @invoice.save(:include=>['lines_attributes']) do | inv, json |
            @new_invoice = inv
            resume
        end

        wait_max 1.0 do
            @new_invoice.visible_id.should.equal 33

        end

    end
end
