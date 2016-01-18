class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lastseenable, :invitable

  has_and_belongs_to_many :conversations
  has_one :kandy_user
  attr_readonly :display_name, :full_name
  attr_accessor :kandy_user_id

  validates_format_of :email, with: Devise::email_regexp

  ROLE = [
      ADMIN = 'admin',
      SUPERUSER = 'superuser',
      OPERATOR = 'operator'
  ]

  STATUS = [
      AVAILABLE = 'available',
      UNAVAILABLE = 'unavailable'
  ]

  ROLE.each do |role|
    define_method "#{role}?" do
      self.role == role
    end
  end

  STATUS.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end

  class << self
    ROLE.each do |role|
      define_method "#{role}" do
        where(role: role)
      end
    end
    STATUS.each do |status|
      define_method "#{status}" do
        where(status: status)
      end
    end

    def online
      self.available.where('last_seen >= ?', Time.now - 2.minutes)
    end
  end

  def display_name
    if full_name != ' '
      full_name
    else
      email
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def kandy_user_id
    return kandy_user.id unless kandy_user.blank?
    nil
  end

  def kandy_user_id=(id)
    kandy_user = KandyUser.find(id)
    self.kandy_user = kandy_user
  end

  def online?
    self.available? && self.last_seen && self.last_seen >= Time.now - 2.minutes
  end

  def stamp!
    if self.last_seen.to_i < (Time.now - 1.minutes).to_i
      self.last_seen = DateTime.now
      self.save!
    end
  end
end
