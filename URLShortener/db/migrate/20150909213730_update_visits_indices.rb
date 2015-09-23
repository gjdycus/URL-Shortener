class UpdateVisitsIndices < ActiveRecord::Migration
  def change
    add_index :visits, :shortened_url_id
    add_index :visits, :user_id

    change_column :visits, :shortened_url_id, :integer, :null => false
    change_column :visits, :user_id, :integer, :null => false
  end
end
