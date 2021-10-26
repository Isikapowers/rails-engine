require "rails_helper"

RSpec.describe "Revenue API" do
  describe "GET revenue of a single merchant" do
    it "returns that merchant with revenue" do
      id = create(:merchant).id
      create_list(:item, 3, merchant_id: id)
      create_list(:invoice, 3, merchant_id: id, status: "shipped")

      create(:invoice_item, item: Item.first, invoice: Invoice.first, quantity: 2, unit_price: 10.00)
      create(:invoice_item, item: Item.second, invoice: Invoice.first, quantity: 1, unit_price: 15.00)
      create(:invoice_item, item: Item.third, invoice: Invoice.second, quantity: 3, unit_price: 20.00)
      create(:invoice_item, item: Item.third, invoice: Invoice.third, quantity: 1, unit_price: 20.00)
      create(:invoice_item, item: Item.first, invoice: Invoice.third, quantity: 3, unit_price: 10.00)

      Invoice.all.each do |invoice|
        create(:transaction, invoice: invoice)
      end

      get "/api/v1/revenue/merchants/#{id}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant.count).to eq(1)

      expect(merchant[:data][:attributes]).to have_key(:revenue)
      expect(merchant[:data][:attributes][:revenue]).to be_a(Float)
      expect(merchant[:data][:attributes][:revenue]).to eq(145.0)
    end
  end

  describe "GET merchants with most revenue" do
    it "returns an amount of merchants with most revenue" do
      merchants = create_list(:merchant, 5)
      merchants.each do |merchant|
        create(:item, merchant: merchant)
        create(:invoice, merchant: merchant, status: "shipped")
      end

      create(:invoice_item, item: Item.first, invoice: Invoice.first, quantity: 2, unit_price: 10.00)
      create(:invoice_item, item: Item.second, invoice: Invoice.second, quantity: 1, unit_price: 15.00)
      create(:invoice_item, item: Item.third, invoice: Invoice.third, quantity: 3, unit_price: 20.00)
      create(:invoice_item, item: Item.fourth, invoice: Invoice.fourth, quantity: 1, unit_price: 20.00)
      create(:invoice_item, item: Item.fifth, invoice: Invoice.fifth, quantity: 3, unit_price: 10.00)

      Invoice.all.each do |invoice|
        create(:transaction, invoice: invoice, result: "success")
      end

      get "/api/v1/revenue/merchants?quantity=3"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(3)

      merchants[:data].each do |merchant|
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
        expect(merchant[:attributes]).to have_key(:revenue)
        expect(merchant[:attributes][:revenue]).to be_a(Float)
      end
    end

    it "returns an error when params not given" do
      merchants = create_list(:merchant, 5)
      merchants.each do |merchant|
        create(:item, merchant: merchant)
        create(:invoice, merchant: merchant, status: "shipped")
      end

      create(:invoice_item, item: Item.first, invoice: Invoice.first, quantity: 2, unit_price: 10.00)
      create(:invoice_item, item: Item.second, invoice: Invoice.second, quantity: 1, unit_price: 15.00)
      create(:invoice_item, item: Item.third, invoice: Invoice.third, quantity: 3, unit_price: 20.00)
      create(:invoice_item, item: Item.fourth, invoice: Invoice.fourth, quantity: 1, unit_price: 20.00)
      create(:invoice_item, item: Item.fifth, invoice: Invoice.fifth, quantity: 3, unit_price: 10.00)

      Invoice.all.each do |invoice|
        create(:transaction, invoice: invoice, result: "success")
      end

      get "/api/v1/revenue/merchants?"

      expect(response).to_not be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:error]).to eq("params not given")
    end
  end

  describe "GET potential revenue of unshipped" do
    it "returns potential revenue of unshipped orders" do
      item = create(:item)
      invoices_shipped = create_list(:invoice, 5, status: "shipped")
      invoices_not_shipped = create_list(:invoice, 10, status: "pending")

      invoices_shipped.each do |invoice|
        create(:invoice_item, item: item, invoice: invoice)
      end

      invoices_not_shipped.each do |invoice|
        create(:invoice_item, item: item, invoice: invoice)
      end

      Invoice.all.each do |invoice|
        create(:transaction, invoice: invoice)
      end

      get "/api/v1/revenue/unshipped"

      expect(response).to be_successful

      invoices = JSON.parse(response.body, symbolize_names: true)

      expect(invoices[:data].count).to eq(10)

      expect(invoices[:data][0][:attributes]).to have_key(:potential_revenue)
      expect(invoices[:data][0][:attributes][:potential_revenue]).to be_a(Float)
    end

    it "renders bad request" do
      item = create(:item)
      invoices_shipped = create_list(:invoice, 5, status: "shipped")
      invoices_not_shipped = create_list(:invoice, 10, status: "pending")

      invoices_shipped.each do |invoice|
        create(:invoice_item, item: item, invoice: invoice)
      end

      invoices_not_shipped.each do |invoice|
        create(:invoice_item, item: item, invoice: invoice)
      end

      Invoice.all.each do |invoice|
        create(:transaction, invoice: invoice)
      end

      get "/api/v1/revenue/unshipped?quantity=0"

      expect(response).to_not be_successful

      invoices = JSON.parse(response.body, symbolize_names: true)

      expect(invoices[:error]).to eq("params not valid")
    end
  end

  describe 'GET revenue weekly' do
    it "return revenue by week" do
      merchants = create_list(:merchant, 5)
      n = 1

      merchants.map do |merchant|
        create(:item, merchant: merchant)
        create(:invoice, merchant: merchant, status: 'shipped', created_at: "2021-09-#{n}")
        n += 4
      end

      create(:invoice_item, item: Item.first, invoice: Invoice.first, quantity: 2, unit_price: 10.00)
      create(:invoice_item, item: Item.second, invoice: Invoice.second, quantity: 1, unit_price: 15.00)
      create(:invoice_item, item: Item.third, invoice: Invoice.third, quantity: 3, unit_price: 20.00)
      create(:invoice_item, item: Item.fourth, invoice: Invoice.fourth, quantity: 2, unit_price: 5.00)
      create(:invoice_item, item: Item.fifth, invoice: Invoice.fifth, quantity: 1, unit_price: 25.00)

      Invoice.all.each do |invoice|
        create(:transaction, invoice: invoice)
      end

      get '/api/v1/revenue/weekly'

      expect(response).to be_successful

      invoices = JSON.parse(response.body, symbolize_names: true)

      expect(invoices[:data].count).to eq(3)

      invoices[:data].each do |invoice|
        expect(invoice[:attributes]).to have_key(:week)
        expect(invoice[:attributes][:week]).to be_a(String)
        expect(invoice[:attributes]).to have_key(:revenue)
        expect(invoice[:attributes][:revenue]).to be_a(Float)
      end
    end
  end
end
