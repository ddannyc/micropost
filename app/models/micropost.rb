class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  # validates :content, length: { maximum: 140 }

  private

    # let content blank when picture present
    def blank_content
      if content.empty? && pictures.emtpy?
        errors.add(:content, " can not be blank.")
      end
    end
end
