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
