class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self

    def get_list(page, per_page)
      offset((page - 1) * per_page).limit(per_page)
    end

    def search(search_params)
      where('name ILIKE ?', "%#{search_params}%").order(:name).first
    end

    def search_all(search_params)
      where('name ILIKE ?', "%#{search_params}%").order(:name)
    end

    def price_search(price_search_params)
      where('unit_price = ?', price_search_params).order(:name).first
    end
  end
end
