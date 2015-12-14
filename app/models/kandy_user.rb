class KandyUser < ActiveRecord::Base
  belongs_to :shop
  belongs_to :user
  validates_uniqueness_of :username, scope: :shop_id

  def kandy_username
    "#{username}@#{domain_name}"
  end
end
