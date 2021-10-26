FactoryBot.define do
  factory :invoice do
    status { "completed" }
    association :merchant, factory: :merchant
    association :customer, factory: :customer
  end
end
