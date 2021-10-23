# frozen_string_literal: true

module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        get_page
        get_per_page
        merchants = Merchant.get_list(get_page, get_per_page)
        render json: MerchantSerializer.new(merchants)
      end

      def show
        merchant = Merchant.find(params[:id])
        render json: MerchantSerializer.new(merchant)
      end
    end
  end
end
