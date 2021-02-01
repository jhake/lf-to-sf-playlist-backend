require "net/http"
require "json"

class SpotifyController < ApplicationController
  before_action :authenticate, :get_spotify_user
  protect_from_forgery with: :null_session

  def get_top_tracks
    puts params
    input_hash = {
      limit: params["limit"] || 10,
      offset: params["offset"] || 0,
      time_range: params["time_range"] || "long_term",
    }
    puts input_hash

    render json: @spotify_user.top_tracks(input_hash)
  end

  def create_playlist
    puts params["spotify"]
    errors = []

    if !params["spotify"]["name"]
      errors.append("name is required")
    elsif params["spotify"]["name"].class.name != "String"
      errors.append("name should be a string")
    end

    if !params["spotify"]["tracks"]
      errors.append("tracks is required")
    elsif params["spotify"]["tracks"].class.name != "Array"
      errors.append("tracks should be an array")
    end

    if errors.length > 0
      render json: errors, status: 400
    else
      begin
        playlist = @spotify_user.create_playlist!(params["spotify"]["name"])
        tracks = playlist.add_tracks!(params["spotify"]["tracks"])
        render json: tracks
      rescue
        render json: { error: "some error occured while creating the playlist" }, status: 500
      end
    end
  end

  def search_spotify_tracks
    puts params
    errors = []

    if !params["queries"]
      errors.append("queries is required")
    elsif params["queries"].class.name != "Array"
      errors.append("queries should be a string")
    elsif params["queries"].length > 10
      errors.append("queries is too long")
    end

    if errors.length > 0
      render json: errors, status: 400
    else
      spotify_tracks = []
      params["queries"].each do |query|
        puts(spotify_tracks.length)
        spotify_track = nil
        while !spotify_track
          begin
            puts query
            results = RSpotify::Track.search(query, limit: 1)
            if results.length == 0
              break
            end
            spotify_track = results.first
            spotify_tracks.append(spotify_track)
            puts "success"
          rescue StandardError => e
            puts "FAIL Rescued: #{e.inspect}"
          end
        end
      end
      render json: spotify_tracks
    end
  end

  def get_user_info
    user_info = { name: @spotify_user.display_name, email: @spotify_user.email, spotify_id: @current_user.spotify_id }
    render json: user_info
  end

  private

  def get_spotify_user
    @spotify_user = RSpotify::User.find(@current_user.spotify_id)
  end
end
