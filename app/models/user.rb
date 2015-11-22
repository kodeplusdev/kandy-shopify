class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lastseenable, :invitable

  has_and_belongs_to_many :conversations
  attr_readonly :display_name, :full_name

  ROLE = [
      ADMIN = 'admin',
      SUPERUSER = 'super_user',
      OPERATOR = 'operator'
  ]

  STATUS = [
      AVAILABLE = 1,
      UNAVAILABLE = 0
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
  end

  def display_name
    full_name || email
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.available
    where(status: User::AVAILABLE).where('last_seen >= ?', Time.now - 2.minutes)
  end

  def stamp!
    if self.last_seen.to_i < (Time.now - 1.minutes).to_i
      self.last_seen = DateTime.now
      self.save!
    end
  end
end
