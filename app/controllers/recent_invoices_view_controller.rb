class RecentInvoicesViewController < UITableViewController

    def init
        @invoices = InvoiceList.new
        super
        self
    end

    def invoiceViewController
        @invoiceViewController ||= InvoiceViewController.alloc.init
    end

    def viewDidLoad
        self.navigationItem.title = "Sales"
        add_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem( UIBarButtonSystemItemAdd,
            target: self, action:'addInvoice'
            )
        self.navigationItem.rightBarButtonItem = add_button
    end

    def addInvoice
        displayInvoice @invoices.prepend( Invoice.new )
    end


    def displayInvoice( invoice )
        self.navigationController.pushViewController( self.invoiceViewController, animated:true )
        self.invoiceViewController.invoice = invoice
    end

    def viewWillAppear( animated )
        super
        if @invoices.empty?
            @invoices.load_page(0) do
                tableView.reloadData
            end
        end
        tableView.reloadData
    end

    # tableView datasource methods

    def tableView(tableView, didSelectRowAtIndexPath:indexPath)
        displayInvoice @invoices.at( indexPath.row )
    end

    def tableView(tableView, numberOfRowsInSection:section)
        @invoices.size
    end

    def tableView(tableView, cellForRowAtIndexPath:indexPath)
        cell = tableView.dequeueReusableCellWithIdentifier('Cell') ||
            InvoiceViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
        cell.invoice = @invoices.at( indexPath.row )
        cell
    end

end
