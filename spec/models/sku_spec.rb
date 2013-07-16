#require 'spec_helper'

describe Sku do
    extend WebStub::SpecHelpers
    extend MotionResource::SpecHelpers

    it "should extract attributes" do
        sku = Sku.new( :code => 'TEST' )
        sku.code.should == 'TEST'
    end

    it "should find single record" do
        stub_request(:get, "http://test.ledgerbuddy.dev/api/skus/10.json").to_return(json: { id: 10 })
        Sku.find(10) do |result|
            @result = result
            resume
        end

        wait_max 1.0 do
            @result.should.is_a Sku
        end
    end

    it "searches skus" do
        stub_request(:get, "http://test.ledgerbuddy.dev/api/skus.json?query%5Bcode%5D=TEST").
            to_return( :json=> { data: [{ id: 10, code: 'TEST'}] } )

        Sku.find_all( { :query => {:code => 'TEST'} } ) do |skus,result|
            @skus = skus
            resume
        end

        wait_max 1.0 do
            @skus.should.is_a Array
            @skus.first.should.is_a Sku
        end
    end

    it "includes images" do
        stub_request(:get, "http://test.ledgerbuddy.dev/api/skus.json?include%5B%5D=images&query%5Bcode%5D=TEST").
            to_return( :json=> { data: [{ id: 10, code: 'TEST',images:[{:id=>1}]}] } )

        Sku.find_all( { :query => {:code => 'TEST'}, :include=>[:images] } ) do |skus,result|
            @skus = skus
            resume
        end

        wait_max 1.0 do
            @skus.should.is_a Array
            @skus.first.should.is_a Sku
        end

    end

end
