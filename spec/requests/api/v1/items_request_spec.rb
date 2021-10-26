require 'rails_helper'

RSpec.describe 'Items Api' do
  describe 'GET items' do
    it 'returns all items' do
      merchant = create(:merchant)
      create_list(:item, 10, merchant_id: merchant.id)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
      end
    end

    it 'returns only 20 items per page when no queried' do
      merchant = create(:merchant)
      create_list(:item, 21, merchant_id: merchant.id)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(20)

      item21 = items[:data].any? do |item|
        item[:attributes][:name] == Item.last.name
      end

      expect(item21).to be(false)
    end

    it 'returns a specific amount of items per page when queried' do
      merchant = create(:merchant)
      create_list(:item, 6, merchant_id: merchant.id)

      get '/api/v1/items?per_page=5'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(5)

      item6 = items[:data].any? do |item|
        item[:attributes][:name] == Item.last.name
      end

      expect(item6).to be(false)
    end

    it 'returns a specific page when queried' do
      merchant = create(:merchant)
      create_list(:item, 21, merchant_id: merchant.id)

      get '/api/v1/items?page=0'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(20)

      item21 = items[:data].any? do |item|
        item[:attributes][:name] == Item.last.name
      end

      expect(item21).to be(false)
    end
  end

  describe 'GET a single item' do
    it 'returns only the item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/#{item.id}"

      expect(response).to be_successful

      item_hash = JSON.parse(response.body, symbolize_names: true)

      expect(item_hash.count).to eq(1)

      expect(item_hash[:data]).to have_key(:id)
      expect(item_hash[:data][:id]).to eq(item.id.to_s)

      expect(item_hash[:data][:attributes]).to have_key(:name)
      expect(item_hash[:data][:attributes][:name]).to eq(item.name)

      expect(item_hash[:data][:attributes]).to have_key(:description)
      expect(item_hash[:data][:attributes][:description]).to eq(item.description)

      expect(item_hash[:data][:attributes]).to have_key(:unit_price)
      expect(item_hash[:data][:attributes][:unit_price]).to eq(item.unit_price)
    end
  end

  describe 'POST items' do
    it 'can create an item' do
      id = create(:merchant).id
      item_params = {
        name: 'Lunch Box',
        description: 'Kids lunch box leak proof',
        unit_price: '19',
        merchant_id: id
      }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      create_item = Item.last

      expect(response).to be_successful

      expect(create_item.name).to eq(item_params[:name])
      expect(create_item.description).to eq(item_params[:description])
      expect(create_item.unit_price).to eq(item_params[:unit_price].to_i)
      expect(create_item.merchant_id).to eq(item_params[:merchant_id])
    end
  end

  describe 'PUT' do
    it 'updates an item' do
      merchant = create(:merchant)
      id = create(:item, merchant_id: merchant.id).id

      previous_name = Item.last.name
      item_params = { name: 'Leak Proof Lunch Box' }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({ item: item_params })
      item = Item.find_by(id: id)

      expect(response).to be_successful

      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq('Leak Proof Lunch Box')
    end
  end

  describe 'GET' do
    it "can get an item's merchant" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful

      merchant_hash = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_hash[:data][:id]).to eq(merchant.id.to_s)
      expect(merchant_hash[:data][:attributes][:name]).to eq(merchant.name)
    end
  end

  describe 'Part2--Non-RESTful' do
    it 'can get a single item with name params' do
      create(:item, name: 'Lunch Box')
      create(:item, name: 'Lulu')
      create(:item, name: 'Luva')

      get '/api/v1/items/find?name=lU'

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item.count).to eq(1)
      expect(item[:data][:attributes][:name]).to eq('Lulu')
    end

    it 'displays an empty hash when name not found' do
      create(:item, name: 'Lunch Box')
      create(:item, name: 'Lulu')
      create(:item, name: 'Luva')

      get '/api/v1/items/find?name=puppy'

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item.count).to eq(1)
      expect(item[:data]).to eq({})
    end

    it 'displays a 400 error when no name given' do
      create(:item, name: 'Lunch Box')
      create(:item, name: 'Lulu')
      create(:item, name: 'Luva')

      get '/api/v1/items/find?name='

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it 'returns all items that match name params' do
      create(:item, name: 'Lunch Box')
      create(:item, name: 'Lulu')
      create(:item, name: 'Luva')

      get '/api/v1/items/find_all?name=lU'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(3)
    end

    it 'finds one item by prices' do
      create(:item, unit_price: 10)
      create(:item, unit_price: 15)
      toy = create(:item, unit_price: 20)

      get '/api/v1/items/find?min_price=20'

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item.count).to eq(1)
      expect(item[:data][:attributes][:name]).to eq(toy.name)
    end
  end
end
