class DropPagesSitesTable < ActiveRecord::Migration
  def up
    drop_table :pages_sites
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
