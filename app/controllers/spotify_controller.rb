require "net/http"
require "json"

class SpotifyController < ApplicationController
  before_action :authenticate, :get_spotify_user
  protect_from_forgery with: :null_session

  def get_top_tracks
    puts params
    input_hash = {
      limit: params["limit"] || 10,
      offset: params["offset"] || 0,
      time_range: params["time_range"] || "long_term",
    }
    puts input_hash

    render json: @spotify_user.top_tracks(input_hash)
  end

  def get_user_info
    user_info = { name: @spotify_user.display_name, email: @spotify_user.email, spotify_id: @current_user.spotify_id }
    render json: user_info
  end

  def get_lf_top_tracks
    url = "https://ws.audioscrobbler.com/2.0/?method=user.gettoptracks&user=elitheiceman163&api_key=#{ENV["lf_api_key"]}&format=json"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)

    render json: JSON.parse(response)
  end

  private

  def get_spotify_user
    @spotify_user = RSpotify::User.find(@current_user.spotify_id)
  end
end
