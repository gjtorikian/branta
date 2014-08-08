class CreatePagesRepositories < ActiveRecord::Migration
  def change
    create_table :pages_repositories do |t|
      t.string :name_with_owner, null: false, default: ""
      t.integer :hook_id, index: true

      t.timestamps
    end
  end
end
