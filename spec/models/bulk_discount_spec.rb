require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :merchant_id }
    it { should validate_presence_of :pct_discount }
    it { should validate_numericality_of :pct_discount }
    it { should validate_presence_of :qty_threshold }
    it { should validate_numericality_of :qty_threshold }
  end
  describe "relationships" do
    it { should belong_to :merchant }
  end
end