class SpotifyController < ApplicationController
  before_action :authenticate
  protect_from_forgery with: :null_session

  def top_tracks
    spotify_user = RSpotify::User.find("rommelmonsayac")

    render json: spotify_user
  end

end
