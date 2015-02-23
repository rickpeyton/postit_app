class User < ActiveRecord::Base
  include Sluggable
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: { minimum: 6 }
  validates :phone, presence: true, if: :two_factor?
  after_validation :clean_phone_number, if: :two_factor?

  def two_factor?
    self.two_factor > 0 ? true : false
  end

  def clean_phone_number
    self.phone.gsub!(/\D/, '')
  end

  sluggable_column :username
end
