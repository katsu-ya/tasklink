class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(team: user.team)
    end
  end

  def show?
    record.team == user.team
  end

  def create?
    user.present? && user.team.present?
  end

  def edit?
    update?
  end

  def update?
    record.team == user.team
  end

  def destroy?
    record.team == user.team
  end
end
