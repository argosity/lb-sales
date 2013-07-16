class InvLineViewCell < UITableViewCell

    include CellWithSku

    attr_reader :line


    def initWithStyle(style, reuseIdentifier:reuseIdentifier)
        super
        self.stylesheet = :order_line_view_cell_sheet
        layout self, :cell do
            create_sku_subviews
            @qty_label   = subview( UILabel, :qty   )
        end
        self
    end

    def line=( line )
        self.setSku( line.sku )
        @price_label.text = '%0.2f' % line.price
        @qty_label.text   = line.qty.to_s
        @line = line
    end

end
