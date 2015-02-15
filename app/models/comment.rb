class Comment < ActiveRecord::Base
  has_many :votes, as: :voteable
  belongs_to :post
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  validates :body, presence: true

  def comment_vote_total
    comment_positive_votes - comment_negative_votes
  end

  def comment_positive_votes
    self.votes.where(vote: true).count
  end

  def comment_negative_votes
    self.votes.where(vote: false).count
  end
end
