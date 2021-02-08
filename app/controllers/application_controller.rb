class ApplicationController < ActionController::Base
  
  def logged_in?
    !!current_user
  end

  def current_user
    return @current_user if @current_user
    if auth_present?
      user_id, access_token_id = Auth.decode_token(read_token_from_request)
      @current_user = Session.get_user_session(user_id, access_token_id)
      return @current_user if @current_user
    end
  end

  def authenticate
    render json: { error: "unauthorized" },
           status: 401 unless logged_in?

  end
  
  def delete_token
    _ , access_token_id = Auth.decode_token(read_token_from_request)
    Session.delete_session_token(access_token_id)
  end

  private

  def read_token_from_request
    token = request.env["HTTP_AUTHORIZATION"]
                   .scan(/Bearer (.*)$/).flatten.last	
  end

  def auth_present?
    !!request.env.fetch("HTTP_AUTHORIZATION", "")
             .scan(/Bearer/).flatten.first	
  end

  def get_spotify_user
    @spotify_user = RSpotify::User.find(@current_user.spotify_id)
  end

end
