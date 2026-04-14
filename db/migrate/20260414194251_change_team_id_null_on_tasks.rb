class ChangeTeamIdNullOnTasks < ActiveRecord::Migration[8.1]
  def change
    change_column_null :tasks, :team_id, true
  end
end
