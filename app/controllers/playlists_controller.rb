require "net/http"
require "json"

class PlaylistsController < ApplicationController
  before_action :authenticate, :get_spotify_user
  protect_from_forgery with: :null_session

  def create_playlist
    errors = []
    if !params["name"]
      errors.append("name is required")
    elsif params["name"].class.name != "String"
      errors.append("name should be a string")
    end

    if !params["tracks"]
      errors.append("tracks is required")
    elsif params["tracks"].class.name != "Array"
      errors.append("tracks should be an array")
    end

    if errors.length > 0
      render json: errors, status: 400
    else
      begin
        spotify_playlist = @spotify_user.create_playlist!(params["name"])
        tracks = spotify_playlist.add_tracks!(params["tracks"])
        user_playlist = Playlist.new
        user_playlist.user_id = @current_user.id
        user_playlist.playlist_id = spotify_playlist.id
        user_playlist.name = spotify_playlist.name
        user_playlist.save

        render json: tracks
      rescue StandardError => e
        puts "FAIL Rescued: #{e.inspect}"
        render json: { error: "some error occured while creating the playlist" }, status: 500
      end
    end
  end

  def get_playlists
    user_playlists = @current_user.playlists
    render json: user_playlists
  end

  def get_playlist

    user_playlist = Playlist.find_by(params[:id])
    spotify_playlist = RSpotify::Playlist.find(@current_user.spotify_id, user_playlist.playlist_id)

    render  json: { name: spotify_playlist.name, tracks: spotify_playlist.tracks }

  end

  def get_spotify_playlists

    playlists =  @spotify_user.playlists(limit: 50)
    playlist_entries = @current_user.playlists

    render  json: {playlists: playlists, playlist_entries: playlist_entries}

  end
end
