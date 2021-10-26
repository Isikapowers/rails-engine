class Invoice < ApplicationRecord
  belongs_to :merchant
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  def self.potential_revenue_unshipped(quantity)
    joins(:invoice_items, :transactions)
      .select("invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as potential_revenue")
      .where("transactions.result = ?", "success")
      .where.not("invoices.status = ?", "shipped")
      .group("invoices.id")
      .limit(quantity)
  end

  def self.weekly_revenue
    joins(:invoice_items, :transactions)
      .where("transactions.result = ? and invoices.status = ?", "success", "shipped")
      .group("date_trunc('week', invoices.created_at)")
      .order(Arel.sql("date_trunc('week', invoices.created_at)"))
      .sum("invoice_items.quantity * invoice_items.unit_price")
  end
end
