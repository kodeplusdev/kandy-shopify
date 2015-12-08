class Conversation < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :shop

  serialize :location, JSON
  serialize :messages, Array

  attr_readonly :title

  RATING = [
      NONE = 'none',
      LIKE = 'like',
      DISLIKE = 'dislike'
  ]

  STATUS = [
      OPEN = 'open',
      CLOSE = 'close'
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

  def self.history(email, ip)
    where('location LIKE ? AND email LIKE ?', "%#{ip}%", "%#{email}%")
  end

  def title
    name || 'anonymous'
  end

  def download
    text =
"Details:
  Date: #{created_at}
  Name: #{title}
  Email: #{email}
  IP Address: #{location['ip']}
  Status: #{status == 'open' ? 'Open' : 'Close'}
  Rating: #{rating == 'like' ? 'Like' : rating == 'dislike' ? 'Dislike' : 'None'}

"
    messages.each do |m|
      json = m['message']['json']
      if json['is_joined'] || json['is_left'] || json['is_closed']
        text += "[#{DateTime.strptime(m['timestamp'], '%s').to_datetime}] #{json['text']}\r"
      else
        text += "[#{DateTime.strptime(m['timestamp'], '%s').to_datetime}] #{json['display_name']} said: #{json['text']}\r"
      end
    end
    text
  end

  def self.today
    where(created_at: Time.now.utc)
  end

  def self.yesterday
    where(created_at: Time.now.utc - 1.day)
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
