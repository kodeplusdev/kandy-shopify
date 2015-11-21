class Conversation < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :shop

  serialize :location, JSON
  serialize :messages, Array

  attr_readonly :title

  RATING = [
      NONE = 0,
      LIKE = 1,
      DISLIKE = -1
  ]

  STATUS = [
      OPEN = 1,
      CLOSE = 0
  ]

  self.per_page = 15

  class << self
    RATING.each do |rating|
      define_method "#{rating}" do
        where(rating: rating)
      end
    end
    STATUS.each do |status|
      define_method "#{status}" do
        where(status: status)
      end
    end
  end

  def self.opens
    where(status: Conversation::OPEN)
  end

  def self.history(email, ip)
    where('location LIKE ? OR email LIKE ?', "%#{ip}%", "%#{email}%")
  end

  def title
    name || 'Visitor'
  end

  def download
"Details:
  Date: #{created_at}
  Name: #{title}
  Email: #{email}
  IP Address: #{location['ip']}
  Status: #{status == 1 ? 'Open' : 'Close'}
  Rating: #{rating == 1 ? 'Like' : rating == -1 ? 'Dislike' : 'None'}
"
  end

  RATING.each do |rating|
    define_method "#{rating}?" do
      self.rating == rating
    end
  end

  STATUS.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end
end
