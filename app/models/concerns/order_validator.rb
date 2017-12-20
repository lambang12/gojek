class OrderValidator < ActiveModel::Validator
  def validate(record)
    destination_must_be_different_than_origin(record)
    locations_must_exist(record)
    distance_cannot_exceed_max_allowed(record)
    distance_matrix_valid(record)
    est_price_cannot_exceed_gopay(record)
  end

  private
    def destination_must_be_different_than_origin(record)
      if record.origin == record.destination
        record.errors.add(:origin, "must be different with pickup location")
        record.errors.add(:destination, "must be different with pickup location")
      end
    end

    def locations_must_exist(record)
      if record.origin_coordinates.blank?
        record.errors.add(:origin, "address not found")
      end

      if record.destination_coordinates.blank?
        record.errors.add(:destination, "address not found")
      end
    end

    def distance_cannot_exceed_max_allowed(record)
      if !record.distance.nil? && record.distance > RulesService::MAX_DISTANCE_ALLOWED
        record.errors.add(:destination, "distance cannot exceed 25 km")
      end
    end

    def distance_matrix_valid(record)
      if !record.distance.nil? && record.distance < 0
        record.errors.add(:base, "Route between places not found")
      end
    end

    def est_price_cannot_exceed_gopay(record)
      if record.payment_type == 'Go-Pay' && record.est_price > record.user.gopay
        record.errors.add(:base, "Insufficient amount of Go-Pay")
      end
    end
end