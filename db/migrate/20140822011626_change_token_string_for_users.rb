class ChangeTokenStringForUsers < ActiveRecord::Migration
  def change
    change_column :users, :token, :string, :default => ""
  end
end
