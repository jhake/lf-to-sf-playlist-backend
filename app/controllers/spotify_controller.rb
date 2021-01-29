class SpotifyController < ApplicationController
  before_action :authenticate
  protect_from_forgery with: :null_session

  def top_tracks
    spotify_user = RSpotify::User.find(@current_user.spotify_id)

    render json: spotify_user.top_tracks()
  end
end
