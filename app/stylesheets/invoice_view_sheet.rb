SPLIT = 100

Teacup::Stylesheet.new( :invoice_view_sheet ) do

    style :lines,
    top: 0, left: 0,
    backgroundColor: UIColor.whiteColor,
    width: '100%',
    height: "100% - #{SPLIT+1}"

    style :charges,
    backgroundColor: UIColor.whiteColor,
    left: 0,
    width: '100%',
    top: "100% - #{SPLIT-1}",
    height: SPLIT-1


    style :tax_label,
    font: UIFont.boldSystemFontOfSize(18.0),
    textAlignment: NSTextAlignmentRight,
    text: 'Tax:',
    left: 100,
    width: '60% - 100',
    top: 5,
    height: 20

    style :tax,
    font: UIFont.boldSystemFontOfSize(18.0),
    textAlignment: NSTextAlignmentRight,
    text: '0.00',
    left: '60%',
    width: '40% - 4',
    top: 5,
    height: 20

    style :total_label,
    font: UIFont.boldSystemFontOfSize(20.0),
    textAlignment: NSTextAlignmentRight,
    text: 'Total:',
    left: 100,
    width: '60% - 100',
    top: 30,
    height: 20

    style :total,
    font: UIFont.boldSystemFontOfSize(20.0),
    textAlignment: NSTextAlignmentRight,
    text: '0.00',
    left: '60%',
    width: '40% - 4',
    top: 30,
    height: 20

    style :save_btn,
    title: 'Save',
    left: 10, top: 15,
    height: 25, width: 80





end
