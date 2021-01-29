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

  def create_playlist
    puts params["spotify"]

    @spotify_user.create_playlist!("test aasdad", description: "description")
    render json: params
  end

  def get_user_info
    user_info = { name: @spotify_user.display_name, email: @spotify_user.email, spotify_id: @current_user.spotify_id }
    render json: user_info
  end

  private

  def get_spotify_user
    @spotify_user = RSpotify::User.find(@current_user.spotify_id)
  end
end
