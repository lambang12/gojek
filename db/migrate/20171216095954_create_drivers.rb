class CreateDrivers < ActiveRecord::Migration[5.1]
  def change
    create_table :drivers do |t|
      t.bigint :external_id
      t.string :full_name
      t.timestamps
    end
  end
end
