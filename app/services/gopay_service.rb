class GopayService
  BASE_URI = 'http://localhost:8080/'
  # rest Rest::Client.new()

  def self.register_gopay(params)
    opts =  {
      body: {
        id: params[:id],
        type: params[:type],
        passphrase: params[:passphrase]
      }
    }
    response = HTTParty.post(BASE_URI, opts)
    RequestResponse.json_to_hash(response)
  end
end