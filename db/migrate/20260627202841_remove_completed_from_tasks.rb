class RemoveCompletedFromTasks < ActiveRecord::Migration[8.1]
  def change
    remove_column :tasks, :completed, :boolean
  end
end
