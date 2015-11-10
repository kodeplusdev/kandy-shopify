class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  include RailsSettings::Extend

  has_one :template
  has_one :profile
  has_many :widgets

  accepts_nested_attributes_for :template, :profile
  attr_accessor :kandy_password, :kandy_password_test


end
