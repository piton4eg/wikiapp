class AddIndexToPosts < ActiveRecord::Migration
  def change
    add_index :posts, :name
  end
end
