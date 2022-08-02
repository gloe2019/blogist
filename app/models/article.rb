class Article < ApplicationRecord
  validates :title, presence: {message: 'Missing a title...'}, uniqueness: true
  validates :body, presence: true, length: { minimum: 50 }
end
