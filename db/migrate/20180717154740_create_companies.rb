class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.index :name
      t.string :name, null: false, unique: true
      t.timestamps null: false
    end
  end
end
