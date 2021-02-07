Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/auth/spotify/callback", to: "sessions#callback"
  get "/top_tracks", to: "spotify#get_top_tracks"
  get "/search_spotify_tracks", to: "spotify#search_spotify_tracks"
  get "/lf_get_request", to: "lastfm#get_request"
  get "/get_user_info", to: "spotify#get_user_info"

  post "/create_playlist", to: "playlists#create_playlist"
  get "/playlists", to: "playlists#get_playlists"
  get "/playlists/:id", to: "playlists#get_playlist"


  delete "/logout", to: "sessions#logout"
end
