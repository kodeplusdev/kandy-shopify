class CreateKandyUsers < ActiveRecord::Migration
  def change
    create_table :kandy_users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :api_key
      t.string :api_secret
      t.string :country_code
      t.string :domain_name
      t.references :shop, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
