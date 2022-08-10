require 'rails_helper'

describe 'Admin Invoices Index Page' do
  before :each do
    @m1 = Merchant.create!(name: 'Merchant 1')
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz', address: '123 Heyyo', city: 'Whoville', state: 'CO', zip: 12345)
    @c2 = Customer.create!(first_name: 'Hey', last_name: 'Heyz')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')


    @item_1a = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_2a = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3a = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4a = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
    @item_7a = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
    @item_8a = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
    
    @invoice_1a = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: '2012-03-25 09:54:09')
    @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: '2012-03-25 09:30:09')

    @item_1 = Item.create!(name: 'test', description: 'lalala', unit_price: 6, merchant_id: @m1.id)
    @item_2 = Item.create!(name: 'rest', description: 'dont test me', unit_price: 12, merchant_id: @m1.id)

    @ii_1a = InvoiceItem.create!(invoice_id: @invoice_1a.id, item_id: @item_1a.id, quantity: 1, unit_price: 10, status: 2)
    @ii_1b = InvoiceItem.create!(invoice_id: @invoice_1a.id, item_id: @item_2a.id, quantity: 2, unit_price: 10, status: 2)
    @ii_1c = InvoiceItem.create!(invoice_id: @invoice_1a.id, item_id: @item_3a.id, quantity: 2, unit_price: 10, status: 2)
    @ii_1d = InvoiceItem.create!(invoice_id: @invoice_1a.id, item_id: @item_4a.id, quantity: 4, unit_price: 10, status: 2)
    @ii_1e = InvoiceItem.create!(invoice_id: @invoice_1a.id, item_id: @item_7a.id, quantity: 9, unit_price: 10, status: 2)
    @ii_1f = InvoiceItem.create!(invoice_id: @invoice_1a.id, item_id: @item_8a.id, quantity: 22, unit_price: 10, status: 2)
    @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 2, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 6, unit_price: 1, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)

    @transaction1a = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1a.id)

    @discount1 = BulkDiscount.create!(name: "20% off 3+ items", pct_discount: 20, qty_threshold: 3, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(name: "30% off 5+ items", pct_discount: 30, qty_threshold: 5, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(name: "15% off 20+ items", pct_discount: 15, qty_threshold: 20, merchant_id: @merchant1.id)

  end

  it 'should display the id, status and created_at' do
    visit admin_invoice_path(@i1)
    expect(page).to have_content("Invoice ##{@i1.id}")
    expect(page).to have_content("Created on: #{@i1.created_at.strftime("%A, %B %d, %Y")}")

    expect(page).to_not have_content("Invoice ##{@i2.id}")
  end

  it 'should display the customers name and shipping address' do
    visit admin_invoice_path(@i1)
    expect(page).to have_content("#{@c1.first_name} #{@c1.last_name}")
    expect(page).to have_content(@c1.address)
    expect(page).to have_content("#{@c1.city}, #{@c1.state} #{@c1.zip}")

    expect(page).to_not have_content("#{@c2.first_name} #{@c2.last_name}")
  end

  it 'should display all the items on the invoice' do
    visit admin_invoice_path(@i1)
    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@item_2.name)

    expect(page).to have_content(@ii_1.quantity)
    expect(page).to have_content(@ii_2.quantity)

    expect(page).to have_content("$#{@ii_1.unit_price}")
    expect(page).to have_content("$#{@ii_2.unit_price}")

    expect(page).to have_content(@ii_1.status)
    expect(page).to have_content(@ii_2.status)

    expect(page).to_not have_content(@ii_3.quantity)
    expect(page).to_not have_content("$#{@ii_3.unit_price}")
    expect(page).to_not have_content(@ii_3.status)
  end

  it 'should display the total revenue the invoice will generate' do
    visit admin_invoice_path(@i1)
    expect(page).to have_content("Total Revenue: $#{@i1.total_revenue}")

    expect(page).to_not have_content(@i2.total_revenue)
  end

  it 'should have status as a select field that updates the invoices status' do
    visit admin_invoice_path(@i1)
    within("#status-update-#{@i1.id}") do
      select('cancelled', :from => 'invoice[status]')
      expect(page).to have_button('Update Invoice')
      click_button 'Update Invoice'

      expect(current_path).to eq(admin_invoice_path(@i1))
      expect(@i1.status).to eq('complete')
    end
  end

    it "shows total revenue and also shows total discounted revenue from this invoice 
  which includes bulk discounts in the calculation" do
  visit admin_invoice_path(@invoice_1a)
    within("#total-revenue") do
      expect(page).to have_content("Total Revenue: $400.00")
    end
    within("#total-discounted-revenue") do
      expect(page).to have_content("Total Discounted Revenue: $299.00")
    end
  end
end
