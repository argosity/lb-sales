class MenuViewController < UITableViewController
    stylesheet :menu_sheet

    ITEMS = [
             {
                 rows: [
                        { title: '' },
                        { title: lambda { 'Logged in as: ' + User.current.username }, key: :user  },
                        { title: 'Print', key: :health_checks  }

                       ]
             }, {
                 title: 'Sales',
                 rows: [
                        { title: 'Recent', key: :recent },
                        { title: 'New',    key: :create }
                       ]

             }, {
                 title: 'Settings',
                 rows: [
                        { title: 'Printer', key: :printer    },
                       ]
             }, {
                 title: 'Account',
                 rows: [
                        { title: 'Logout', key: :logout }
                       ]
             }
            ]

    def init
        super
        layout tableView, :table
        self
    end

    def numberOfSectionsInTableView(tableView)
        ITEMS.size
    end

    def tableView(tableView, numberOfRowsInSection:section)
        ITEMS[section][:rows].size
    end

    def tableView(tableView, titleForHeaderInSection:section)
        ITEMS[section][:title]
    end

    def tableView(tableView, cellForRowAtIndexPath:indexPath)
        fresh_cell.tap do |cell|
            text = ITEMS[indexPath.section][:rows][indexPath.row][:title]
            text = text.call if text.respond_to?(:call)
            cell.textLabel.text = text
        end
    end

    def tableView(tableView, heightForHeaderInSection:section)
        section == 0 ? 0 : 30
    end

    def tableView(tableView, viewForHeaderInSection:section)
        view = UIView.alloc.initWithFrame([[0, 0], [320, 30]])
        layout(view, :header) do
            subview(UIView, :bottom_line)
            label = subview(UILabel, :header_label)
            label.text = tableView(tableView, titleForHeaderInSection:section)
        end
        view
    end

    def tableView(tableView, didSelectRowAtIndexPath:indexPath)
        selected = ITEMS[indexPath.section][:rows][indexPath.row][:key]

        viewController = case selected
                         when :printer
                             PrintersViewController.alloc.init
                         when :create
                             @create ||= InvoiceViewController.alloc.init
                         when :recent
                             @recent ||= RecentInvoicesViewController.alloc.init
                         else
                             SitesViewController.alloc.init
                         end

        self.viewDeckController.centerController = NavigationController.alloc.initWithRootViewController(viewController)

        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        self.viewDeckController.toggleLeftView
    end

    def logout
        MotionResource::Base.default_url_options = nil
        UIApplication.sharedApplication.keyWindow.rootViewController = LoginViewController.alloc.init
    end

    private

    def fresh_cell
        tableView.dequeueReusableCellWithIdentifier('Cell') ||
            UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell').tap do |cell|
            layout cell, :cell do
                subview(UIView, :top_line)
                subview(UIView, :bottom_line)
            end
            cell.setSelectedBackgroundView(layout(UIView.alloc.init, :selected))
        end
    end
end
