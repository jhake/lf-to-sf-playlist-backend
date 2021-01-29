require "active_support/core_ext/hash/except"

class LastfmController < ApplicationController
  def get_request
    url = "https://ws.audioscrobbler.com/2.0/?api_key=#{ENV["lf_api_key"]}&format=json"

    params.except("controller", "action").each do |key, value|
      url += "&#{key}=#{value}"
    end

    uri = URI(url)
    json_response = Net::HTTP.get(uri)

    response = JSON.parse(json_response)

    render json: response
  end
end
