require 'rails_helper'

RSpec.describe 'Merchants API' do
  describe 'GET merchants' do
    it 'sends a list of all merchants' do
      create_list(:merchant, 5)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(5)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_an(String)
      end
    end

    it 'has a default limit of 20 and start with page 1' do
      create_list(:merchant, 21)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(20)

      merchant21 = merchants[:data].any? do |merchant|
        merchant[:attributes][:name] == Merchant.last.name
      end

      expect(merchant21).to be(false)
    end

    it 'returns an amount of merchants per page when queried' do
      create_list(:merchant, 11)

      get '/api/v1/merchants?per_page=10'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(10)

      merchant11 = merchants[:data].any? do |merchant|
        merchant[:attributes][:name] == Merchant.last.name
      end

      expect(merchant11).to be(false)
    end

    it 'returns a specific page when queried' do
      create_list(:merchant, 21)

      get '/api/v1/merchants?page=2'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(1)

      merchant21 = merchants[:data].any? do |merchant|
        merchant[:attributes][:name] == Merchant.last.name
      end

      expect(merchant21).to be(true)
    end
  end

  describe 'GET a single merchant' do
    it 'can get one single merchant by id' do
      merchant = create(:merchant)

      get "/api/v1/merchants/#{merchant.id}"

      expect(response).to be_successful

      merchant_hash = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_hash[:data]).to have_key(:id)
      expect(merchant_hash[:data][:id]).to eq(merchant.id.to_s)

      expect(merchant_hash[:data][:attributes]).to have_key(:name)
      expect(merchant_hash[:data][:attributes][:name]).to eq(merchant.name)
    end
  end

  describe 'GET items of that merchant' do
    it "returns a list of that merchant's items" do
      id = create(:merchant).id
      create_list(:item, 5, merchant_id: id)

      get "/api/v1/merchants/#{id}/items"

      expect(response).to be_successful

      items_hash = JSON.parse(response.body, symbolize_names: true)

      expect(items_hash[:data].count).to eq(5)

      items_hash[:data].each do |item|
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
  end
end
