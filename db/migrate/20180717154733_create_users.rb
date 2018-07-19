class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :first_name
      t.string :last_name
      add_index(:email, unique: true)
      t.timestamps null: false
    end
  end
end
