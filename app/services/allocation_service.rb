module AllocationService
  BASE_URI = 'http://localhost:3001/'

  def self.allocate_driver_to_order(params)
    order = Order.find(params["order_id"])
    if params["status"] == 'OK'
      driver = Driver.find_or_create_by(external_id: params["driver"]["id"], full_name: params["driver"]["first_name"])
      order.update(status: 'D', driver: driver)
    else
      order.update(status: 'C')
    end
  end

  def self.update_order(params)
    opts =  {
      body: params
    }
    response = HTTParty.put("#{BASE_URI}orders", opts)
    RequestResponse.json_to_hash(response)
  end
end