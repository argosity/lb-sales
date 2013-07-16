Teacup::Stylesheet.new :invoice_view_cell_sheet do

    style :visible_id,
    font: UIFont.boldSystemFontOfSize(17.0),
    textColor: UIColor.blackColor,
    highlightedTextColor: UIColor.whiteColor,
    autoresizingMask: UIViewAutoresizingFlexibleWidth,
    left: 5,
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

    style :occured,
    font: UIFont.systemFontOfSize(14.0),
    textColor: UIColor.darkGrayColor,
    highlightedTextColor: UIColor.whiteColor,
    autoresizingMask: UIViewAutoresizingFlexibleWidth,
    left: 5,
    top: 25,
    width: lambda { superview.bounds.size.width - 66 },
    height: 16

end
