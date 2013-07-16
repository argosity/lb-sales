class InvoiceViewCell < UITableViewCell

    attr_reader :invoice


    def initWithStyle(style, reuseIdentifier:reuseIdentifier)
        super
        self.stylesheet = :invoice_view_cell_sheet
        layout self, :cell do
            @id_label = subview(UILabel, :visible_id)
            @time_label = subview(UILabel, :occured)
            @price_label = subview( UILabel, :price )
            # @qty_label   = subview( UILabel, :qty   )
        end
        self
    end

    def invoice=( inv )
        @id_label.text = inv.visible_id ? inv.visible_id.to_s : 'UNSAVED'
        @price_label.text  = '%0.2f' % inv.total.to_f
        @time_label.text = ( inv.created_at || Time.now ).strftime( '%I:%M%p %a, %b %m %Y')

        # @qty_label.text   = line.qty.to_s
        # @line = line

    end

end
