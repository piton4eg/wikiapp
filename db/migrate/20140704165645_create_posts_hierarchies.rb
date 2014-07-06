class CreatePostsHierarchies < ActiveRecord::Migration
  def change
    create_table :post_hierarchies, :id => false do |t|
      t.integer  :ancestor_id, :null => false   # ID of the parent/grandparent/great-grandparent/... tag
      t.integer  :descendant_id, :null => false # ID of the target tag
      t.integer  :generations, :null => false   # Number of generations between the ancestor and the descendant. Parent/child = 1, for example.
    end

    add_index :post_hierarchies, [:ancestor_id, :descendant_id, :generations],
      :unique => true, :name => "post_anc_desc_udx"

    add_index :post_hierarchies, [:descendant_id],
      :name => "post_desc_idx"
  end
end
