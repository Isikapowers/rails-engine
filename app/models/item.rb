class Item < ApplicationRecord
  validates :name, :description, :unit_price, presence: true

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  def self.most_revenue(quantity)
    joins(:transactions)
      .select("items.*, sum(invoice_items.unit_price * invoice_items.quantity) as revenue")
      .where("invoices.status = ? and transactions.result = ?", "shipped", "success")
      .group("items.id")
      .order("revenue desc")
      .limit(quantity)
  end
end
