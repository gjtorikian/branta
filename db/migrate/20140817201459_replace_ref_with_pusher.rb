class ReplaceRefWithPusher < ActiveRecord::Migration
  def change
    remove_column :pages_builds, :ref
    add_column    :pages_builds, :pusher, :string, :required => true
  end
end
