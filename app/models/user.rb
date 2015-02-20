class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: { minimum: 6 }

  after_validation :create_slug, on: :create

  def to_param
    "#{self.slug}"
  end

  def create_slug
    self.slug = self.username.downcase
    trim_non_url_characters
    trim_repeat_hyphens
    trim_leading_and_trailing_hyphen
    check_for_slug_uniqueness
  end

  def trim_non_url_characters
    self.slug.gsub!(/[^a-z0-9\-]/, '-')
  end

  def trim_repeat_hyphens
    self.slug.gsub!(/-{2,}/, '-')
  end

  def trim_leading_and_trailing_hyphen
    self.slug.gsub!(/(^-)|(-$)/, '')
  end

  def check_for_slug_uniqueness
    if User.exists?(slug: self.slug)
      self.add_digit_to_end_of_slug
    else
      return self
    end
  end

  def add_digit_to_end_of_slug
    counter = 2
    while User.exists?(slug: "#{self.slug}-#{counter}")
      counter += 1
    end
    self.slug = self.slug + "-#{counter}"
  end

end
