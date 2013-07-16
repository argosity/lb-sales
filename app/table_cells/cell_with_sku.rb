module CellWithSku

    def create_sku_subviews
        @image = subview( UIImageView, :image )
        @code_label = subview(UILabel, :code)
        @description_label = subview(UILabel, :description)
        @price_label = subview( UILabel, :price )
    end

    def setSku(sku)
        @sku = sku
        @code_label.text = sku.code
        @description_label.text = sku.description
        @price_label.text = '%0.2f' % ( sku.default_uom ? sku.default_uom.base_price.to_f : 0.0 )
        if sku.thumbnail_url
            @image.setImageWithURL(NSURL.URLWithString( sku.thumbnail_url )
                )
        else
            @image.setImage( UIImage.imageNamed("blank.png") )
        end
    end


end
