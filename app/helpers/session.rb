class Session

  def self.create_session_token(user_id)
    access_token = AccessToken.new
    access_token.user_id = user_id
    access_token.save
    access_token.id
  end

  def self.get_user_session(user_id, access_token_id)
    access_token = AccessToken.find_by(id: access_token_id)
    if access_token
      user_credentials = RSpotify::User.class_variable_get('@@users_credentials')[user_id] if RSpotify::User.class_variable_defined?('@@users_credentials')
      if user_credentials
        return User.find_by({ spotify_id: user_id })
      else 
        delete_session_token(access_token_id)
        return nil
      end
    end

  end

  def self.delete_session_token(access_token_id)
    access_token = AccessToken.find_by(id: access_token_id)
    access_token.destroy unless access_token.nil?
  end

  
end