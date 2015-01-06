class RenamePagesBuildColumn < ActiveRecord::Migration
  def change
    rename_column :pages_builds, :repository_id, :repo_id
  end
end
