Teacup::Stylesheet.new :sku_view_cell_sheet do
    style :cell

    style :image,
    contentMode: UIViewContentModeScaleAspectFit,
    width: 50,
    height: 50

    style :code,
    font: UIFont.boldSystemFontOfSize(17.0),
    textColor: UIColor.blackColor,
    highlightedTextColor: UIColor.whiteColor,
    autoresizingMask: UIViewAutoresizingFlexibleWidth,
    left: 53,
    top: 3,
    width: lambda { superview.bounds.size.width - 66 },
    height: 20

    style :price,
    font: UIFont.boldSystemFontOfSize(19.0),
    textColor: UIColor.blackColor,
    highlightedTextColor: UIColor.whiteColor,
    autoresizingMask: UIViewAutoresizingFlexibleWidth,
    textAlignment: NSTextAlignmentRight,
    top: 5,
    left: lambda { superview.bounds.size.width - 80 },
    width: 75,
    height: 16

    style :description,
    font: UIFont.systemFontOfSize(14.0),
    textColor: UIColor.darkGrayColor,
    highlightedTextColor: UIColor.whiteColor,
    autoresizingMask: UIViewAutoresizingFlexibleWidth,
    left: 53,
    top: 25,
    width: lambda { superview.bounds.size.width - 66 },
    height: 16

end
