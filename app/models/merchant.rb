class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices, through: :items, dependent: :destroy
  has_many :transactions, through: :invoices

  def self.merchant_total_revenue(merchant_params)
    joins(:transactions)
      .select("merchants.id, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
      .where("transactions.result = ? and invoices.status = ?", "success", "shipped")
      .group("merchants.id")
      .find(merchant_params)
  end

  def self.most_revenue_by_merchants(quantity_params)
    joins(:transactions)
      .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
      .where("transactions.result = ? and invoices.status = ?", "success", "shipped")
      .group("merchants.id")
      .order("revenue DESC")
      .limit(quantity_params)
  end
end
