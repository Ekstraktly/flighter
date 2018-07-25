class AddTokenToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :token, :string, null: false, default: '', unique: true
  end

  def down
    remove_column :token
  end
end
