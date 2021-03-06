class Group < ApplicationRecord
  validates_presence_of :name, :calendar_id
  has_many :users
  has_many :days
  has_many :posts, through: :days
end
