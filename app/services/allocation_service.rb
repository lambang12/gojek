class AllocationService
  def self.allocate_driver_to_order(params)
    order = Order.find(params["order_id"])
    if params["status"] == 'OK'
      driver = Driver.find_or_create_by(external_id: params["driver"]["id"], full_name: params["driver"]["first_name"])
      order.update(status: 'Driver Assigned', driver: driver)
    else
      order.update(status: 'Cancelled by System')
    end
  end

  # def self.update_order(params)
  #   opts =  {
  #     body: params
  #   }
  #   response = HTTParty.put("#{BASE_URI}orders", opts)
  #   RequestResponse.json_to_hash(response)
  # end

  def self.find_initialized_orders
    begin
      cancels = Order.find_5_minutes_initialized
      cancelled_if_not_allocated(cancels)
    ensure
      ActiveRecord::Base.connection_pool.release_connection
    end
  end

  def self.cancelled_if_not_allocated(orders)
    orders.each do |order|
      order.reload
      if order.status == "Initialized"
        unless order.update(status: 'Cancelled by System')
          puts order.errors.to_s
          puts order.errors.to_a
        end
      end
    end
  end
end