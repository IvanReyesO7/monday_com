require 'net/http'
require 'uri'
require 'json'

def request(query)
  uri = URI.parse("https://api.monday.com/v2")
  request = Net::HTTP::Post.new(uri)
  request.content_type = "application/json"
  request["Authorization"] = ENV["MONDAY_COM_TOKEN"]
  request.body = JSON.dump({
    "query" => query
  })

  req_options = {
    use_ssl: uri.scheme == "https",
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  response_hash = JSON.parse(response.body)["data"]
end
