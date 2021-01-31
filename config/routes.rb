Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/auth/spotify/callback", to: "sessions#callback"
  get "/top_tracks", to: "spotify#get_top_tracks"
  get "/search_spotify_tracks", to: "spotify#search_spotify_tracks"
  get "/lf_get_request", to: "lastfm#get_request"

  post "/create_playlist", to: "spotify#create_playlist"
end
