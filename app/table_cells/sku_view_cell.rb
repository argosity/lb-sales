class SkuViewCell < UITableViewCell

    include CellWithSku

    attr_reader :sku


    def initWithStyle(style, reuseIdentifier:reuseIdentifier)
        super

        self.stylesheet = :sku_view_cell_sheet

        layout self, :cell do
            create_sku_subviews
        end
        self
    end


end
