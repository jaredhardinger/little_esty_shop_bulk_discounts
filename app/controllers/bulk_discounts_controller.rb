require './app/poros/holiday_search'
class BulkDiscountsController < ApplicationController
    before_action :find_merchant
    before_action :find_discount, only: [:show, :destroy, :edit, :update]

    def index 
        @holidays = HolidaySearch.new.next_three_holidays
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
            flash[:alert] = "You screwed something up. Try again."
        end 
    end

    def destroy
        @discount.destroy
        redirect_to request.referrer
    end

    def edit
    end

    def update
        if @discount.update(discount_params)
            redirect_to "/merchant/#{@merchant.id}/bulk_discounts/#{@discount.id}"
            flash.notice = "Discount has been successfully updated"
        else
            redirect_to request.referrer
            flash[:alert] = "You screwed something up. Try again."
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