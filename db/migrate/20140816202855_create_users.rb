class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    end
  end
end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :login,       :null => false, :unique => true
      t.string  :token,       :null => false
      t.integer :github_id,   :null => false, :unique => true
    end
    add_index :users, :login
  end
end
