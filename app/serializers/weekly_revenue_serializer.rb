class WeeklyRevenueSerializer
  def self.format_data(id, revenue)
    {
      "data": map_revenue(id, revenue)
    }
  end

  def self.map_revenue(id, revenue)
    revenue.map do |key, value|
      {
        "id": id,
        "type": "weekly_revenue",
        "attributes": {
          "week": key.to_date.to_s,
          "revenue": value
        }
      }
    end
  end
end
