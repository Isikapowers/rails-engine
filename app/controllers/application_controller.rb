class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def get_page
    if params[:page] = "0"
      params[:page].to_i
    else
      params.fetch(:page, 1).to_i
    end
  end

  def get_per_page
    params.fetch(:per_page, 20).to_i
  end
end
