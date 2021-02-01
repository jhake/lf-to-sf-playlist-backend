class Lf
  def self.get_request(params)
    url = "https://ws.audioscrobbler.com/2.0/?api_key=#{ENV["lf_api_key"]}&format=json"

    params.each do |key, value|
      url += "&#{key}=#{value}"
    end

    uri = URI(url)
    json_response = Net::HTTP.get(uri)
    response = JSON.parse(json_response)

    return response
  end
end
