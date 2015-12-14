class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  include RailsSettings::Extend

  has_one :template
  has_many :users
  has_many :conversations
  has_one :widget
  has_many :kandy_users

  accepts_nested_attributes_for :template, :widget

  def kandy_user_guest
    KandyUser.where(shop_id: id).find(kandy_user_guest_id)
  end
end
