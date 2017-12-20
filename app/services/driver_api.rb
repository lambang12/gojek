class DriverApi
  BASE_URI = 'http://localhost:3001/api/v1/'

  def self.send_check_request(user)
    opts = {
      body: {
        email: user.email,
        phone: user.phone
      }
    }
    response = HTTParty.post("#{BASE_URI}check_user", opts)
    RequestResponse.json_to_hash(response)
  end
end
