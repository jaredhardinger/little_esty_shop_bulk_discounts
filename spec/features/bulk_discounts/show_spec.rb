require 'rails_helper'

RSpec.describe 'merchant discount show' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @discount1 = BulkDiscount.create!(name: "20% off 10+ items", pct_discount: 20, qty_threshold: 10, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(name: "30% off 15+ items", pct_discount: 30, qty_threshold: 15, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(name: "15% off 20+ items", pct_discount: 15, qty_threshold: 20, merchant_id: @merchant1.id)

    visit merchant_bulk_discount_path(@merchant1, @discount3)
  end

    it "When I visit my bulk discount show page
    then I see the bulk discount's quantity threshold and percentage discount" do
        expect(page).to have_content(@discount3.name)
        expect(page).to have_content("Discount: #{@discount3.pct_discount}%")
        expect(page).to have_content("Quantity Threshold: #{@discount3.qty_threshold}")
        expect(page).to_not have_content(@discount1.name)
        expect(page).to_not have_content("Discount: #{@discount1.pct_discount}%")
        expect(page).to_not have_content("Quantity Threshold: #{@discount1.qty_threshold}")
    end

    it "has a link to edit the bulk discount
    and when I click this link
    then I am taken to  a new page with a form to edit the discount
    and I see that the discount's current attributes are pre-populated in the form
    When I change any/all of the information and click 'submit'
    then I am redirected to the bulk discount's show page
    and I see that the discount's attributes have been updated" do
        expect(page).to have_link("Edit Discount")
        click_link("Edit Discount")
        expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/#{@discount3.id}/edit")
        expect(find_field('Discount Name').value).to eq('15% off 20+ items')
        expect(find_field('Percent Discount').value).to eq('15')
        expect(find_field('Quantity Threshold').value).to eq('20')
        fill_in "Name", with: "50% off 62+ Items"
        fill_in "Percent Discount", with: 50
        fill_in "Quantity Threshold", with: 62
        click_button "Save"
        expect(current_path).to eq merchant_bulk_discount_path(@merchant1, @discount3)
        expect(page).to have_content("50% off 62+ Items")
        expect(page).to have_content("Discount: 50%")
        expect(page).to have_content("Quantity Threshold: 62")

        #Happy path
        expect(page).to have_content("Discount has been successfully updated")

        #Sad paths
        click_link("Edit Discount")
        fill_in "Percent Discount", with: 101
        click_button "Save"
        expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/#{@discount3.id}/edit")
        expect(page).to have_content("You screwed something up. Try again.")
        
        fill_in "Quantity Threshold", with: -62
        click_button "Save"
        expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/#{@discount3.id}/edit")
        expect(page).to have_content("You screwed something up. Try again.")
        
        fill_in "Name", with: ""
        click_button "Save"
        expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/#{@discount3.id}/edit")
        expect(page).to have_content("You screwed something up. Try again.")
    end
end