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

  def to_param
    "#{self.slug}"
  end

  def create_slug
    binding.pry
    title = self.title
    trim_non_url_characters(title)
  end

  def trim_non_url_characters(title)
    title.gsub(/[^a-z0-9\-]/, '-').trim_repeat_hyphen
  end

  def trim_repeat_hyphens
    self.gsub(/-{2,}/, '-').trim_trailing_hyphen
  end

  def trim_trailing_hyphen
    self.gsub(/\-$/, '').check_for_slug_uniqueness
  end

  def check_for_slug_uniqueness
    if Post.exists?(slug: self)
      self.add_id_to_end_of_slug
    else
      return self
    end
  end

  def add_digit_to_end_of_slug
    self + @post.id.to_s
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
