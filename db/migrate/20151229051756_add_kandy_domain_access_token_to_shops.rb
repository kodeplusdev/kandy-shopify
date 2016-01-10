class AddKandyDomainAccessTokenToShops < ActiveRecord::Migration
  def change
    add_column :shops, :kandy_domain_access_token, :string
  end
end
