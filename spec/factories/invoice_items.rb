FactoryBot.define do
  factory :invoice_item do
    quantity { Faker::Number.within(range: 1..10) }
    unit_price { Faker::Number.within(range: 1.0..1000.0) }
    association :item, factory: :item
    association :invoice, factory: :invoice
  end
end
