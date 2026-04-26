class TasksController < ApplicationController
    before_action :authenticate_user!

    def index
      @tasks = current_user.tasks

      if params[:keyword].present?
        @tasks = @tasks.where("title LIKE ?", "%#{params[:keyword]}%")
      end

      @tasks = @tasks.order(created_at: :desc).page(params[:page]).per(6)
    end

    def new
      @task = Task.new
    end

    def create
      @task = current_user.tasks.new(task_params)

      if @task.save
       redirect_to tasks_path, notice: "投稿しました"
      else
       render :new, status: :unprocessable_entity
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
