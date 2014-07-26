class CreatePagesSites < ActiveRecord::Migration
  def change
    create_table :pages_sites do |t|
      t.string :name

      t.timestamps
    end
  end
end
