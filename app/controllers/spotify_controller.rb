class SpotifyController < ApplicationController
  def callback
    r = request.env["omniauth.auth"]
    spotify_user = RSpotify::User.new(request.env["omniauth.auth"])
    # Now you can access user's private data, create playlists and much more

    render json: { response: "success" }
  end
end
