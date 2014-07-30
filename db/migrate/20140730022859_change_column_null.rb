class ChangeColumnNull < ActiveRecord::Migration
  def change
    change_column_null :users, :token, false
  end
end
