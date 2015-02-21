module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable
  end

  def vote_count
    positive_votes - negative_votes
  end

  def positive_votes
    self.votes.where(vote: true).count
  end

  def negative_votes
    self.votes.where(vote: false).count
  end
end
