class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :complete]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discounted_revenue
    total_revenue-total_discount
  end

  def total_discount
    invoice_items
      .joins(:bulk_discounts)
      .where('invoice_items.quantity >= bulk_discounts.qty_threshold')
      .select('invoice_items.*, max(invoice_items.unit_price * invoice_items.quantity *(bulk_discounts.pct_discount)/100.00) as discount')
      .group('invoice_items.id')
      .sum(&:discount)
  end
end
