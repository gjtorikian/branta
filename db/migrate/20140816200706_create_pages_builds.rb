class CreatePagesBuilds < ActiveRecord::Migration
  def change
    create_table :pages_builds do |t|
      t.string :status,          :required => true
      t.string :guid,            :required => true
      t.string :name,            :required => true
      t.string :name_with_owner, :required => true
      t.string :ref,             :required => true
      t.string :sha,             :required => true

      t.timestamps
    end
  end
end
