Teacup::Stylesheet.new :order_line_view_cell_sheet do
    style :cell

    import :sku_view_cell_sheet


    style :qty,
    font: UIFont.boldSystemFontOfSize(17.0),
    textColor: UIColor.darkGrayColor,
    highlightedTextColor: UIColor.whiteColor,
    autoresizingMask: UIViewAutoresizingFlexibleWidth,
    textAlignment: NSTextAlignmentRight,
    top: 25,
    left: lambda { superview.bounds.size.width - 30 },
    width: 25,
    height: 16


end
