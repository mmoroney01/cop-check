class CreateIncidents < ActiveRecord::Migration[5.1]
  def change
    create_table :incidents do |t|
      t.float :latitude
      t.float :longitude
      t.string :description, null: false
      t.string :address, null: false
      
      t.timestamps
    end
  end
end
