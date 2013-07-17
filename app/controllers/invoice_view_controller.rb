class InvoiceViewController < UIViewController


    stylesheet :invoice_view_sheet

    def init
        @invoice = Invoice.new
        super
    end

    layout do
        @table = subview( UITableView, :lines )
        @table.delegate   = self
        @table.dataSource = self

        @charges = subview(UIView, :charges) do
            @save = subview( UIButton.buttonWithType( UIButtonTypeRoundedRect ), :save_btn )
            @save.addTarget(self,action:'saveInvoice:', forControlEvents:UIControlEventTouchUpInside)

            subview(UILabel,:tax_label)
            @tax   = subview(UILabel,:tax)

            subview(UILabel,:total_label)
            @total = subview(UILabel,:total)
        end
    end

    def skuFinderController
        @skuFinder ||= SkuFinderViewController.alloc.init
    end

    def invoice=(invoice)
        @invoice = invoice
        @invoice.lines do | lines, resp |
            @invoice.updateTotal
            self.refreshData
        end
    end

    def refreshData
        @table.reloadData
        @total.text = '%0.2f' % @invoice.total
        name = @invoice.new_record? ? 'NEW SALE' : @invoice.visible_id
        @header.text = "%s\n%0.2f" % [ name, @invoice.total.to_f ]
        tax = @invoice.tax_line
        @tax.text = '%0.2f' % ( tax ? tax.total : 0 )
    end

    def saveInvoice( *args )
        unless @invoice.valid?
            SVProgressHUD.showErrorWithStatus("Please fill in Customer & Location in settings")
            return
        end

        @invoice.save(:include=>['lines_attributes']) do | inv, json |
            @invoice.list
            list = @invoice.list
            if indx = list.find_index( @invoice )
                list.delete_at( indx )
            end
            self.invoice = list.prepend( inv )
            inv.updateTotal
        end
    end

    def itemInformationViewController
        @itemInfo  ||= ItemInformationViewController.alloc.init
    end

    def skuWasSelected(sku)
        @invoice.addSku( sku )
        refreshData
    end


    def viewDidLoad
        super
        @header = UILabel.alloc.initWithFrame( CGRectMake(0, 0, 480, 44) )
        @header.backgroundColor = UIColor.clearColor
        @header.numberOfLines = 2;
        @header.font = UIFont.boldSystemFontOfSize( 14.0 )
        @header.textAlignment = UITextAlignmentCenter
        self.navigationItem.titleView = @header

        recognizer = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:'handleSwipe:')
        self.view.addGestureRecognizer(recognizer)

        recognizer = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:'handleSwipe:')
        recognizer.direction = UISwipeGestureRecognizerDirectionLeft
        self.view.addGestureRecognizer(recognizer)

        add_button = UIBarButtonItem.alloc.
            initWithBarButtonSystemItem( UIBarButtonSystemItemAdd,
                                         target: self, action:'addItem' )
        self.navigationItem.rightBarButtonItem = add_button
    end

    def handleSwipe(recognizer)
        locationInView = recognizer.locationInView(@table)
        indexPath = @table.indexPathForRowAtPoint(locationInView)
        if indexPath
            cell = @table.cellForRowAtIndexPath(indexPath)
            diff = recognizer.direction == UISwipeGestureRecognizerDirectionLeft ?  1 : -1
            cell.line.adjQty( diff )
        end
    end

    def viewWillAppear( animated )
        super
        self.navigationController.setToolbarHidden( true, animated:false )
    end

    def addItem
        self.navigationController.pushViewController( self.skuFinderController, animated:true )
        self.skuFinderController.itemDelegate = self
    end

    # tableView delegate / datasource methods

    def tableView(tableView, didSelectRowAtIndexPath:indexPath)
        line = @invoice.regular_lines[ indexPath.row ]
        self.itemInformationViewController.sku = line.sku
        self.navigationController.pushViewController( itemInformationViewController, animated:true )
    end

    def tableView(tableView, numberOfRowsInSection:section)
        @invoice.regular_lines.size
    end

    def tableView(tableView, heightForRowAtIndexPath:indexPath )
        return 50
    end

    def tableView(tableView, cellForRowAtIndexPath:indexPath)
        cell = @table.dequeueReusableCellWithIdentifier('Cell') ||
            InvLineViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
        cell.line = @invoice.regular_lines[ indexPath.row ]
        cell
    end


end
