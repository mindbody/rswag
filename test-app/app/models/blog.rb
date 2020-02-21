# frozen_string_literal: true

class Blog < ActiveRecord::Base
  validates :content, presence: true

  def as_json(_options)
    {
      id: id,
      title: title,
      content: nil,
      thumbnail: thumbnail
    }
  end
end
