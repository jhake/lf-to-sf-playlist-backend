class Auth
  def self.encode_uid(user_id)
    access_token = AccessToken.new
    access_token.user_id = user_id
    access_token.save
    payload = {
      iat: Time.now.to_i,
      jti: SecureRandom.uuid,
      iss: "LastFM to Spotify Playlist",
      data: { 
        user_id: user_id,
        access_token_id: access_token.id
      }
    }
    JWT.encode payload, ENV['jwt_secret'], 'HS256'
  end
  
  def self.decode_uid(token)
    payload = JWT.decode token, ENV['jwt_secret'], true,
              { :algorithm => 'HS256' }
    payload[0]['data']['user_id'] unless AccessToken.find_by(id: payload[0]['data']['access_token_id']).nil?
  end

  def self.delete_token(token)
    payload = JWT.decode token, ENV['jwt_secret'], true,
    { :algorithm => 'HS256' }
    access_token = AccessToken.find_by(id: payload[0]['data']['access_token_id'])
    access_token.destroy
  end

end