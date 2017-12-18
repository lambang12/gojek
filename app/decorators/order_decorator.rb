class OrderDecorator < Draper::Decorator
  delegate_all

  def distance_in_km
    "#{distance} km"
  end

  def idr_price
    h.number_to_currency(est_price, unit: "Rp ", delimiter: ".", separator: ",")
  end

  def idr_fare
    h.number_to_currency(base_fare, unit: "Rp ", delimiter: ".", separator: ",")
  end

  def order_date
    created_at.strftime("%d %B %Y %H:%M:%S")
  end
end
