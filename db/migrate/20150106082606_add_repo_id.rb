class AddRepoId < ActiveRecord::Migration
  def change
    add_column :repositories, :repo_id, :integer, :null => false
    add_index :repositories, :repo_id
  end
end
