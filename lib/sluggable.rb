module Sluggable
  extend ActiveSupport::Concern

  included do
    after_validation :create_slug, on: :create
    class_attribute :slug_column
  end

  def to_param
    "#{self.slug}"
  end

  def create_slug
    self.slug = self.send(self.class.slug_column.to_sym).downcase
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
    if self.class.exists?(slug: self.slug)
      self.add_digit_to_end_of_slug
    else
      return self
    end
  end

  def add_digit_to_end_of_slug
    counter = 2
    while self.class.exists?(slug: "#{self.slug}-#{counter}")
      counter += 1
    end
    self.slug = self.slug + "-#{counter}"
  end

  module ClassMethods
    def sluggable_column(column)
      self.slug_column = column
    end
  end

end
