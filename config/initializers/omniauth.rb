require "rspotify/oauth"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV["spotify_client_id"], ENV["spotify_client_secret"], 
    scope: "playlist-modify-public playlist-modify-private playlist-read-private playlist-read-collaborative user-top-read user-read-email user-read-playback-state user-modify-playback-state"
end
