# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    unit_price  { Faker::Number.within(range: 50..100_000) }
    association :merchant, factory: :merchant
  end
end
