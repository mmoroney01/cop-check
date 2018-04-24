class CreateIncidents < ActiveRecord::Migration[5.1]
  def change
    create_table :incidents do |t|
      t.string :location, null: false
      t.string :description, null: false
      
      t.timestamps
    end
  end
end
