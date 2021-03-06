# frozen_string_literal: true

module Api
  module V1
    class ItemMerchantsController < ApplicationController
      def show
        merchant = Item.find(params[:id]).merchant
        render json: MerchantSerializer.new(merchant)
      end
    end
  end
end
