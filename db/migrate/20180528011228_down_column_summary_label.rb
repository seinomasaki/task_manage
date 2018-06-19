class DownColumnSummaryLabel < ActiveRecord::Migration[5.2]
  def change
    remove_column :summaries, :label, :string
  end
end
