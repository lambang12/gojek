class OrderSerializer < ActiveModel::Serializer
  attributes :id, 
    :origin,
    :destination,
    :distance,
    :base_fare,
    :est_price,
    :status,
    :rating,
    :comment,
    :payment_type,
    :origin_latitude,
    :origin_longitude,
    :destination_latitude,
    :destination_longitude
  belongs_to :type
  belongs_to :user
end
