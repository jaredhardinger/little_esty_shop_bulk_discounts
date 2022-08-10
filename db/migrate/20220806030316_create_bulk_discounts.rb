class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.string :name
      t.integer :pct_discount
      t.integer :qty_threshold
    end
  end
end