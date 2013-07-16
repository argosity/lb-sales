class PrintersViewController < UITableViewController

    def init
        super
        layout tableView, :table
        self.navigationItem.title = 'Printers'
        @printers = []
        self
    end

    def viewWillAppear( animated )
        super
        Printer.available do | printers |
            @printers = printers
            tableView.reloadData
        end
    end

    def tableView(tableView, didSelectRowAtIndexPath:indexPath)
        Printer.selected = @printers.at( indexPath.row )
        tableView.reloadData
    end

    def tableView(tableView, numberOfRowsInSection:section)
        @printers.size
    end

    def tableView(tableView, cellForRowAtIndexPath:indexPath)
        cell = tableView.dequeueReusableCellWithIdentifier('Cell') ||
            UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'Cell')
        printer = @printers[ indexPath.row ]
        cell.image = UIImage.imageNamed( printer.is_selected? ? "star.png" : "blank.png" )
        cell.text = printer.name
        cell
    end


end
