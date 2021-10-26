require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many(:items) }
    it { should have_many(:invoices).through(:items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe "#merchant_total_revenue" do
    it "returns total revenue for that merchant" do
      merchant = create(:merchant)

      item = create(:item, merchant: merchant)
      invoice = create(:invoice, merchant: merchant, status: "shipped")

      create(:invoice_item, item: item, invoice: invoice, quantity: 2, unit_price: 10.00)
      create(:invoice_item, item: item, invoice: invoice, quantity: 1, unit_price: 15.00)
      create(:invoice_item, item: item, invoice: invoice, quantity: 3, unit_price: 20.00)

      Invoice.all.each do |invoice|
        create(:transaction, invoice: invoice, result: "success")
      end

      expect(Merchant.merchant_total_revenue(merchant.id).revenue).to eq(95)
    end
  end

  describe "#most_revenue_by_merchants" do
    it "returns merchants with most revenue" do
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

      expect(Merchant.most_revenue_by_merchants(2)).to eq([merchants.third, merchants.fifth])
    end
  end
end
