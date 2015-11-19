class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  include RailsSettings::Extend

  has_one :template
  has_many :users
  has_many :conversations
  has_one :widget

  accepts_nested_attributes_for :template, :widget


end
