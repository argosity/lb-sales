class ItemInformationViewController < UIViewController

    stylesheet :item_view_sheet


    layout do
        self.view.backgroundColor = UIColor.whiteColor

        @carousel = subview( ICarousel, :carousel )
        @carousel.type       = ICarouselTypeLinear
        @carousel.delegate   = self
        @carousel.dataSource = self

        @description = subview( UIWebView, :description )
    end

    def init
        super
    end


    def item=(item)
        @item = item
        @carousel.reloadData
        self.navigationItem.title = @item.title
        url = NSURL.URLWithString( "http://iogee.ledgerbuddy.dev/" )
        @description.loadHTMLString( @item.description + @item.extended_description, baseURL: url )
    end

    def sku=( sku )
        sku.items do | items |
            self.item = items.first if items.any?
        end
    end

    def numberOfItemsInCarousel( carousel )
        if @item
            @item.images.count
        else
            0
        end
    end

    def carouselItemWidth(carousel)
        return 280
    end

    def carousel( carousel, viewForItemAtIndex:index, reusingView:view )
        image = @item.images[ index ].medium
        if view == nil
            view = UIImageView.alloc.initWithFrame( CGRectMake( 0, 0, image.width, image.height ) )
        end
        url =  "http://iogee.ledgerbuddy.dev#{image.url}"
        view.setImageWithURL(NSURL.URLWithString( url ),
            placeholderImage: UIImage.imageNamed("blank.png")
            )
        view
    end


end
