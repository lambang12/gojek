class UrlApi
  API_URL = 'http://example.com/create'

  def unique_url
    response = HTTParty.get(API_URL)
    # TODO more error checking (500 error, etc)
    json = JSON.parse(response.body)
    json['url']
  end
end