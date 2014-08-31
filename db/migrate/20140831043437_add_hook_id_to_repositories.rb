class AddHookIdToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :hook_id, :integer, :required => true
  end
end
