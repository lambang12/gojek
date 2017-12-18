module AllocationService
  BASE_URI = 'http://localhost:3001/'

  def self.allocate_driver_to_order(params)
    order = Order.find(params["order_id"])
    if params["status"] == 'OK'
      puts params["driver"]["id"]
      driver = Driver.find_or_create_by(external_id: params["driver"]["id"], full_name: params["driver"]["first_name"])
      order.update(status: 'Driver Assigned', driver: driver)
    else
      order.update(status: 'Cancelled by System')
    end
  end

  def self.update_order(params)
    opts =  {
      body: params
    }
    response = HTTParty.put("#{BASE_URI}orders", opts)
    RequestResponse.json_to_hash(response)
  end


  def self.find_initialized_orders
    #Please try using querying from model. It should not be in decorator or somewhere else. you should write this in model only. Let me know if this works.
    begin
      puts 'find Initialized orders'
      orders = Order.where("status = 'Initialized'")
      cancels = orders.select { |o| (Time.now - o.created_at) > 300 }
      cancelled_if_not_allocated(cancels)
    ensure
      ActiveRecord::Base.connection_pool.release_connection
    end
  end

  def self.cancelled_if_not_allocated(orders)
    orders.each do |order|
      order.reload
      if order.status == "Initialized"
        order.update(status: 'Cancelled by System')
        MessagingService.produce_order_cancellation(order)
      end
    end
  end
end