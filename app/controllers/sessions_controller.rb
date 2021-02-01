class SessionsController < ApplicationController
  protect_from_forgery with: :null_session


  def callback

    spotify_user = RSpotify::User.new(auth)
    user = User.find_or_create_by(spotify_id: spotify_user.id)

    if user
      jwt = Auth.encode_uid(user.spotify_id)
      cookies[:token] = { value: jwt, httponly: true }
      redirect_to(ENV['client_url'] + "login")
    else
      redirect_to(ENV['client_url'])
    end


  end

  def logout
    delete_token
    render json: "Logout successful"
  end

  private
  def auth
    request.env['omniauth.auth']
  end
end
