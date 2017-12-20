class AddPhoneAndLicenseToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :phone, :string
    add_column :drivers, :license_plate, :string
  end
end
