class Shop < ActiveRecord::Base
  include ShopifyApp::Shop

  has_one :template

  accepts_nested_attributes_for :template
  attr_accessor :kandy_password

end
