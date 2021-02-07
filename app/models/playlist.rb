class Playlist < ApplicationRecord
  validates :playlist_id, presence: true

  belongs_to :user
end
