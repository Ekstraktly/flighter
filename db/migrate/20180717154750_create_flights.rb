class CreateFlights < ActiveRecord::Migration[5.2]
  def change
    create_table :flights do |t|
      t.belongs_to :company, index: true, foreign_key: true
      t.string :name
      t.integer :no_of_seats
      t.integer :base_price
      t.date :flys_at
      t.date :lands_at
      t.timestamps null: false
    end
  end
end
