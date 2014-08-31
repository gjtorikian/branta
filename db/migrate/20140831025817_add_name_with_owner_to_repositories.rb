class AddNameWithOwnerToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :name_with_owner, :string, :required => true
    add_index :repositories, :name_with_owner
  end
end
