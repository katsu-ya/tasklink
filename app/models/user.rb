class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  belongs_to :team, optional: true

  has_many :tasks, dependent: :destroy
end
