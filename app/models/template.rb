class Template < ActiveRecord::Base
  belongs_to :shop
  after_initialize :set_default, if: :new_record?

  def set_default
    # TODO
  end
end
