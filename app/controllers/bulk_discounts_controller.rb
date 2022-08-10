class BulkDiscountsController < ApplicationController
    before_action :find_merchant, only: [:index, :show, :new, :create]
    before_action :find_discount, only: [:show]

    def index 
    end

    def show
    end

    def new
    end

    def create
        new_discount = @merchant.bulk_discounts.create(discount_params)
        if new_discount.save
            redirect_to "/merchant/#{@merchant.id}/bulk_discounts"
            flash.notice = "Discount has been successfully created"
        else
            redirect_to "/merchant/#{@merchant.id}/bulk_discounts/new"
            flash[:alert] = "Error: #{error_message(new_discount.errors)}"
        end 
    end

private
    def discount_params
        params.permit(:name, :pct_discount, :qty_threshold)
    end

    def find_merchant
        @merchant = Merchant.find(params[:merchant_id])
    end

    def find_discount
        @discount = @merchant.bulk_discounts.find(params[:id])
    end
end