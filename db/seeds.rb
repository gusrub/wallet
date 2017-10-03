# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin = User.create(email: "admin@walletapi.xyz", password: "Testing@123!", password_confirmation: "Testing@123!", first_name: "Admin", last_name: "User", role: User.roles[:admin], status: User.statuses[:active])
Account.create(balance: 1000000, account_type: Account.account_types[:internal], user: admin)