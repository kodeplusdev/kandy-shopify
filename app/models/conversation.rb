class Conversation < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :shop

  serialize :location, JSON
  serialize :messages, Array

  attr_readonly :title

  RATING = [
      NONE = 0,
      VERY_BAD = 1,
      BAD = 2,
      NORMAL = 3,
      GOOD = 4,
      VERY_GOOD = 5
  ]

  STATUS = [
      OPEN = 'open',
      CLOSE = 'close'
  ]

  self.per_page = 15

  class << self
    STATUS.each do |status|
      define_method "#{status}" do
        where(status: status)
      end
    end

    def ratings(rating)
      where(rating: rating)
    end

    def history(email, ip)
      where('location LIKE ? AND email LIKE ?', "%#{ip}%", "%#{email}%")
    end

    def today
      where('created_at >= ?', Time.now.utc.beginning_of_day)
    end

    def yesterday
      where('created_at >= ? AND created_at < ?', Time.now.utc.beginning_of_day - 1, Time.now.utc.beginning_of_day)
    end
  end

  def title
    name || 'anonymous'
  end

  def first_operator
    User.where(shop_id: shop_id, id: first_operator_id).first
  end

  def download
    text =
"Details:
  Date: #{created_at}
  Name: #{title}
  Email: #{email}
  IP Address: #{location['ip']}
  Status: #{status == 'open' ? 'Open' : (first_operator_id ? 'Close' : 'Missed')}
  Rating: #{rating > 0 ? rating : 'Not rated'}
"
    messages.each do |m|
      if m['is_joined'] || m['is_left'] || m['is_closed']
        text += "[#{DateTime.strptime(m['timestamp'], '%s').to_datetime}] #{m['text']}\n"
      else
        text += "[#{DateTime.strptime(m['timestamp'], '%s').to_datetime}] #{m['display_name']} said: #{m['text']}\n"
      end
    end
    text
  end

  STATUS.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end

  def rating?(rating)
    self.rating = rating
  end
end
