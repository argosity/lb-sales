LedgerBuddy.server = "http://test.example.com/"
MotionResource::Base.root_url = "#{LedgerBuddy.server}api/"


def spec_url( comp, params={} )
    LedgerBuddyModel.url_encoder
        .insert_extension(
            LedgerBuddyModel.url_encoder.build_query_string( MotionResource::Base.root_url + comp, params ),
        '.json' )
end



module LB

    module SpecHelper

        def self.setup_network_stubs( base )
            base.disable_network_access!

            base.stub_request(:get, spec_url('skus/tax', {
                                            :include=>[:locations,:uoms]
                                        })
                              )
                .to_return( json: { data:
                                { id: 111, code: 'TAX' }
                            } )

            Sku.tax
        end

        def self.extended(base)

            base.send(:extend, MotionResource::SpecHelpers )
            base.send(:extend, WebStub::SpecHelpers )

            base.class.send(:include, ::LB::SpecHelper::Methods)

            setup_network_stubs(base)
        end

        module Methods
            extend self

            def test_sku
                Sku.new({   :id=>1,
                            :code=>'test'
                        })
            end

        end

    end

end
