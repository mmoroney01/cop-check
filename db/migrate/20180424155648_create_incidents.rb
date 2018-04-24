class CreateIncidents < ActiveRecord::Migration[5.1]
  def change
    create_table :incidents do |t|
      t.string :street
      t.string :city
      t.string :zip
      t.string :state
      t.float :latitude
      t.float :longitude
      t.string :description, null: false
      
      t.timestamps
    end
  end
end
