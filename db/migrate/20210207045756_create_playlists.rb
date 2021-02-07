class CreatePlaylists < ActiveRecord::Migration[6.1]
  def change
    create_table :playlists do |t|
      t.string :playlist_id
      t.integer :user_id
      t.string :name
      t.timestamps
    end
    add_index :playlists, :playlist_id
    add_index :playlists, :user_id
    add_index :users, :spotify_id
  end
end
