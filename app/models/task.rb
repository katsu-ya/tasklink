class Task < ApplicationRecord
  belongs_to :user
  belongs_to :team, optional: true

  enum :status, { todo: 0, doing: 1, done: 2 }
end