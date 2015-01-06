class MakePagesBuildsColumnsNonNullable < ActiveRecord::Migration
  def change
    change_column :pages_builds, :name, :string, :null => false
    change_column :pages_builds, :name_with_owner, :string, :null => false
    change_column :pages_builds, :sha, :string, :null => false
  end
end
