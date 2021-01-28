class SessionsController < ApplicationController

  def callback

    spotify_user = RSpotify::User.new(auth)
    user = User.find_or_create_by(spotify_id: spotify_user.id)

    if user
      jwt = Auth.encode_uid(user.spotify_id)
      redirect_to(ENV['client_url'] + "login?token=#{jwt}")
    else
      redirect_to(ENV['client_url'])
    end


  end

  def auth
    request.env['omniauth.auth']
  end
end
