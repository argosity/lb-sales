class DeckController < IIViewDeckController

    def init
        super
        self.leftController   = ::MenuViewController.alloc.init
        self.centerController = ::NavigationController.alloc.init
        self.leftSize = 160
        self.panningMode = IIViewDeckNavigationBarPanning

        self.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose
        self
    end

end
