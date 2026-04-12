class TasksController < ApplicationController
    before_action :authenticate_user!

    def index
      @tasks = Task.includes(:user).order(created_at: :desc)
    end

    def new
      @task = Task.new
    end

    def create
      @task = current_user.tasks.build(task_params)
      if @task.save
        redirect_to root_path, notice: "作成しました"
      else
        render :new
      end
    end

    private

    def task_params
      params.require(:task).permit(:title, :description, :status, :team_id)
    end
end
