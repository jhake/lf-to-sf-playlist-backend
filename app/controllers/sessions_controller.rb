class SessionsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate, only: :logout

  def callback

    spotify_user = RSpotify::User.new(auth)
    user = User.find_or_create_by(spotify_id: spotify_user.id)
    
    if user
      access_token_id = Session.create_session_token(spotify_user.id)
      jwt = Auth.encode_token(user.spotify_id, access_token_id)
      redirect_to(ENV['client_url'] + "/login?token=#{jwt}")
    else
      redirect_to(ENV['client_url'])
    end

  end

  def logout
    render json: "Logout successful" if delete_token
  end

  private
  def auth
    request.env['omniauth.auth']
  end
end
