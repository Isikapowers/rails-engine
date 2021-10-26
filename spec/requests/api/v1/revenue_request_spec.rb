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
  end
end
