class TasksController < ApplicationController
    before_action :authenticate_user!

    def index
      @tasks = current_user.tasks.order(created_at: :desc)
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

    def edit
      @task = current_user.tasks.find(params[:id])
    end

    def update
      @task = current_user.tasks.find(params[:id])
      if @task.update(task_params)
        redirect_to root_path, notice: "更新しました"
      else
        render :edit
      end
    end

    def destroy
      @task = current_user.tasks.find(params[:id])
      @task.destroy
      redirect_to root_path, notice: "削除しました"
    end

    private

    def task_params
      params.require(:task).permit(:title, :description, :status, :team_id)
    end
end
