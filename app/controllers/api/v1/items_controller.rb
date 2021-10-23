module Api
  module V1
    class ItemsController < ApplicationController
      def index
        get_page
        get_per_page
        items = Item.get_list(get_page, get_per_page)
        render json: ItemSerializer.new(items)
      end

      def show
        item = Item.find(params[:id])
        render json: ItemSerializer.new(item)
      end

      def create
        item = Item.new(item_params)
        if item.save
          render json: ItemSerializer.new(item), status: :created
        else
          render_unprocessable(item)
        end
      end

      def update
        item = Item.find(params[:id])
        if item.update(item_params)
          render json: ItemSerializer.new(item)
        else
          render_validation(item)
        end
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
