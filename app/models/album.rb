class Album < ApplicationRecord
  belongs_to :user
  belongs_to :cover_photo, class_name: :Photo, foreign_key: :cover
  has_many :photos, dependent: :destroy
  validates :user_id, presence: true
  validates :title, presence: true
end
