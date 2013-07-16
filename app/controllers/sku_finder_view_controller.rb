class SkuFinderViewController < UITableViewController

    attr_accessor :itemDelegate

    def init
        @skus = []
        super
    end


    def viewWillAppear( animated )
        super
        self.navigationController.setToolbarHidden( false, animated:false )
    end

    def filter_items
        %w{ Code Description VPart# }
    end



    def viewDidAppear( animated )
        super
        @search.becomeFirstResponder

        @search.text = '28'
        self.searchBarSearchButtonClicked( @search )
    end

    # def searchBar(search_bar, textDidChange:searchText)
    #     puts "search text changed #{searchText} '#{search_bar.text}'"
    # end

    def searchBarSearchButtonClicked(search_bar)
        search = search_bar.text

        params = case @filter.selectedSegmentIndex
                when 0
                     { :query => { 'code' => "#{search}%" } }
                when 1
                     { :query => { 'description' => "%#{search}%" } }
                else
                     { :scope => { 'with_vendor_sku_code' => "#{search}%"} }
                end
        Sku.find_all( params.merge( :include=>[:images,:locations,:uoms], :limit=>15 ) ) do | skus, resp |
            @skus = skus
            tableView.reloadData
        end
    end



    def tableView(tableView, didSelectRowAtIndexPath:indexPath )
        @sku = @skus[ indexPath.row ]
        @itemDelegate.skuWasSelected( @sku ) if @itemDelegate
        self.navigationController.popViewControllerAnimated(true)
    end

    def tableView(tableView, heightForRowAtIndexPath:indexPath )
        return 50
    end

    def tableView(tableView, cellForRowAtIndexPath:indexPath)
        fresh_cell.tap do |cell|
            sku = @skus[indexPath.row]
            cell.setSku( sku )
        end
    end

    def tableView(tableView, numberOfRowsInSection:section)
        @skus.size
    end

    def itemInformationController
        @itemInfo  ||= ItemInformationViewController.alloc.init
    end


    def handleSwipe(recognizer)
        indexPath = @table.indexPathForRowAtPoint(locationInView)
        itemInformationViewController.sku = @skus[ indexPath.row ]
        self.navigationController.pushViewController( itemInformationViewController, animated:true )
    end

    def viewDidLoad
        super

        kbv = UIView.alloc.initWithFrame( CGRectMake(0.0, 0.0, 320.0, 44.0 ) )
        tb = UIToolbar.alloc.initWithFrame( kbv.frame )
        tb.setBarStyle(UIBarStyleBlackTranslucent)

        if UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad
            tb.tintColor = UIColor.colorWithRed( 0.6, green:0.6, blue:0.64, alpha:1.0 )
        else
            tb.tintColor = UIColor.colorWithRed( 0.56, green:0.59, blue:0.63, alpha:1.0 )
        end

        kbv.addSubview( tb )

        @filter = UISegmentedControl.alloc.initWithItems(filter_items)
        @filter.segmentedControlStyle = UISegmentedControlStyleBar
        @filter.selectedSegmentIndex = 0


        space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
        tb.items = [space, UIBarButtonItem.alloc.initWithCustomView(@filter), space]


        @search = UISearchBar.alloc.init
        @search.delegate = self
        self.navigationItem.titleView = @search
        self.navigationItem.titleView.frame = CGRectMake(0, 0, 170,44)
        @search.inputAccessoryView = kbv

        recognizer = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:'handleSwipe:')
        self.view.addGestureRecognizer(recognizer)

    end

    def fresh_cell
        tableView.dequeueReusableCellWithIdentifier('Cell') ||
            SkuViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell').tap do |cell|
        end
    end

end
