class Template < ActiveRecord::Base
  belongs_to :shop
  validates_uniqueness_of :shop_id
  before_validation :set_default

  def set_default
    # TODO
  end
end
