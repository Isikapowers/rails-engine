FactoryBot.define do
  factory :transaction do
    credit_card_number { Faker::Business.credit_card_number }
    credit_card_expiration_date { '1025' }
    result { 'success' }
    association :invoice, factory: :invoice
  end
end
