class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id, unique: true
      t.integer :shortened_url_id, null: false
      t.boolean :upvote, null: false
      t.timestamps
    end
  end
end
