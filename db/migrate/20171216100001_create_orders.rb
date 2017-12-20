class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :origin
      t.string :destination
      t.float :distance
      t.float :base_fare
      t.float :est_price
      t.string :status
      t.float :rating
      t.text :comment
      t.string :payment_type
      t.string :origin_coordinates
      t.string :destination_coordinates
      t.references :type
      t.references :user
      t.references :driver
      t.timestamps
    end
  end
end
