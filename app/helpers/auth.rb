class Auth
  def self.encode_token(user_id, access_token_id)
    payload = {
      iat: Time.now.to_i,
      jti: SecureRandom.uuid,
      iss: "LastFM to Spotify Playlist",
      data: { 
        user_id: user_id,
        access_token_id: access_token_id
      }
    }
    JWT.encode payload, ENV['jwt_secret'], 'HS256'
  end
  
  def self.decode_token(token)
    payload = JWT.decode token, ENV['jwt_secret'], true,
              { :algorithm => 'HS256' }
    return payload[0]['data']['user_id'], payload[0]['data']['access_token_id'] if payload
  end
end
