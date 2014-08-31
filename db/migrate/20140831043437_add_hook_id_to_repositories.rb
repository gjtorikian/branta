class AddHookIdToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :hook_id, :string, :required => true
  end
end
