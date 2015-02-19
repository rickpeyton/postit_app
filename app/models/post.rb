class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable
  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true
  validates :category_ids, presence: true

  after_create :create_slug

  def to_param
    "#{self.slug}"
  end

  def create_slug
    self.slug = self.title.downcase
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
    if Post.exists?(slug: self.slug)
      self.add_digit_to_end_of_slug
    else
      return self
    end
  end

  def add_digit_to_end_of_slug
    counter = 2
    while Post.exists?(slug: "#{self.slug}-#{counter}")
      counter += 1
    end
    self.slug = self.slug + "-#{counter}"
  end

  def post_vote_count
    post_positive_votes - post_negative_votes
  end

  def post_positive_votes
    self.votes.where(vote: true).count
  end

  def post_negative_votes
    self.votes.where(vote: false).count
  end
end
