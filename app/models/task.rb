class Task < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validates :title,
            presence: true,
            length: { maximum: 100 }

  enum :status, { todo: 0, doing: 1, done: 2 }
end
