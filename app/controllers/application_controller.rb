class ApplicationController < ActionController::Base
  
  def logged_in?
    !!current_user
  end

  def current_user
    return @current_user if @current_user
    if auth_present?
      uid = Auth.decode_uid(read_token_from_request)
      @current_user = User.find_by({ spotify_id: uid })
      return @current_user if @current_user
    end
  end

  def authenticate
    render json: { error: "unauthorized" },
           status: 401 unless logged_in?

  end
  
  def delete_token
    Auth.delete_token(read_token_from_request)
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
