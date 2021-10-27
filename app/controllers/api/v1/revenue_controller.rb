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

  def unshipped
    quantity = params.fetch(:quantity, 10).to_i
    if quantity != 0
      invoices = Invoice.potential_revenue_unshipped(quantity)
      render json: UnshippedOrderSerializer.new(invoices)
    else
      render_bad_request("params not valid")
    end
  end

  def weekly
    id = nil
    revenue = Invoice.weekly_revenue
    render json: WeeklyRevenueSerializer.format_data(id, revenue)
  end

  def items
    quantity = params.fetch(:quantity, 10).to_i
    if quantity != 0
      items = Item.most_revenue(quantity)
      render json: ItemRevenueSerializer.new(items)
    else
      render_bad_request("params not valid")
    end
  end
end
