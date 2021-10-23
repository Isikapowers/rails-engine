class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_unprocessable(object)
    render json: { error: object.errors.full_messages }, status: :unprocessable_entity
  end

  def render_validation(object)
    render json: { error: object.errors.full_messages }, status: :not_found
  end

  def render_bad_request(message)
    render json: { error: message }, status: :bad_request
  end

  def get_page
    if params[:page].to_i <= 0
      params[:page] = 1
    elsif params[:page].nil?
      params.fetch(:page, 1).to_i
    else
      params[:page].to_i
    end
  end

  def get_per_page
    if params[:per_page].nil?
      params.fetch(:per_page, 20).to_i
    else
      params[:per_page].to_i
    end
  end
end
