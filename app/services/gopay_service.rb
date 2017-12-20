class GopayService
  BASE_URI = 'http://localhost:8080/'

  def self.register_gopay(user)
    opts = set_params(user)
    response = HTTParty.post(BASE_URI, opts)
    puts response.body
    RequestResponse.json_to_hash(response.body)
  end

  def self.topup(user, amount, order = nil)
    puts "patch top up"
    opts = set_params(user, amount, order)
    response = HTTParty.put("#{BASE_URI}topup", opts)
    puts response.body
    RequestResponse.json_to_hash(response.body)
  end

  def self.use(user, amount, order = nil)
    opts = set_params(user, amount, order)
    response = HTTParty.put(BASE_URI, opts)
    puts response.body
    RequestResponse.json_to_hash(response.body)
  end

  def self.set_params(*params)
    {
      body: {
        id: params[0].id,
        type: 'customer',
        passphrase: params[0].password_digest,
        amount: params[1],
        order_id: !params[2].nil? ? params[2].id : "",
        order_status: !params[2].nil? ? params[2].status : ""
      }
    }
  end
end