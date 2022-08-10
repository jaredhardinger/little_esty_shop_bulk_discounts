class BulkDiscount < ApplicationRecord
  validates_presence_of :name,
                        :merchant_id
  validates :pct_discount, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates :qty_threshold, presence: true, numericality: { greater_than: 0 }
                        
  belongs_to :merchant
end
