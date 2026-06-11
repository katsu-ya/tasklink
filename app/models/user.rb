class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  belongs_to :team, optional: true

  has_many :tasks, dependent: :destroy

  after_create :create_default_team

  private

  def create_default_team
    team = Team.create!(
      name: "#{email.split('@').first}のチーム"
    )

    update_column(:team_id, team.id)
  end
end
