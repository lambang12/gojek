class DriverService
  BASE_URI = 'http://localhost:3001/api/v1/'

  def self.user_exists?(params)
    puts "posting #{params}"
    opts = {
      body: params
    }
    response = HTTParty.post("#{BASE_URI}check_user", opts)
    puts response.body
    RequestResponse.json_to_hash(response)
  end
end