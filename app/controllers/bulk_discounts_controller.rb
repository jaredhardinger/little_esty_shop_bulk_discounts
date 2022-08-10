class BulkDiscountsController < ApplicationController
    before_action :find_merchant, only: [:index, :show]
    before_action :find_discount, only: [:show]

    def index 
    end

    def show

    end

    private
    def find_merchant
        @merchant = Merchant.find(params[:merchant_id])
    end

    def find_discount
        @discount = @merchant.bulk_discounts.find(params[:id])
    end
end