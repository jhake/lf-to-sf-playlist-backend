class CreateAccessTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :access_tokens do |t|
      t.string :user_id
      t.timestamps
    end
  end
end
