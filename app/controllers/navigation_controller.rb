class NavigationController < UINavigationController

    def init
        initWithRootViewController( RecentInvoicesViewController.alloc.init )
#        self.toolbarHidden = true #false
        self
    end

    def initWithRootViewController(view_controller)
        super

        self.toolbarHidden = true #false
        self
    end
end
