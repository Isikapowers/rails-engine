class Api::V1::RevenueController < ApplicationController
  def show
    merchant = Merchant.find(params[:id])
    revenue = Merchant.merchant_total_revenue(merchant.id)
    render json: MerchantRevenueSerializer.new(revenue)
  end

  def quantity_merchants
    if params[:quantity]
      merchants = Merchant.most_revenue_by_merchants(params[:quantity])
      render json: MerchantNameRevenueSerializer.new(merchants)
    else
      render_bad_request("params not given")
    end
  end
end
