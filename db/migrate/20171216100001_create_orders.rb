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
      t.float :origin_latitude
      t.float :origin_longitude
      t.float :destination_latitude
      t.float :destination_longitude
      t.references :type
      t.references :user
      t.references :driver
      t.timestamps
    end
  end
end
