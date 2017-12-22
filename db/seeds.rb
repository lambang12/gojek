# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# User.delete_all
# Type.delete_all

# Type.create!(
#   [
#     {
#       name: "Go-Ride",
#       base_fare: 1500.0
#     },
#     {
#       name: "Go-Car",
#       base_fare: 2500.0
#     }
#   ]
# )


User.create!(
  [
    {
      email: "potter@gryff.com", 
      first_name: "Harry", 
      last_name: "Potter", 
      password: 'password', 
      password_confirmation:'password',
      phone:'08117878789'
    },
    {
      email: "granger@gryff.com", 
      first_name: "Hermione", 
      last_name: "Granger", 
      password: 'password', 
      password_confirmation:'password',
      phone:'08765657657'
    },
    {
      email: "weasley6@gryff.com", 
      first_name: "Ronald", 
      last_name: "Weasley", 
      password: 'password', 
      password_confirmation:'password',
      phone:'0867686689'
    }
  ]
)
