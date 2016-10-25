class Album < ApplicationRecord
  belongs_to :user
  has_many :photos, dependent: :destroy
  validates :user_id, presence: true
  validates :title, presence: true
  validates :cover, presence: true
end
