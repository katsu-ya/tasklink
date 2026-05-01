class TasksController < ApplicationController
    before_action :authenticate_user!

    def index
      @tasks = current_user.tasks

       # 🔽 フィルター
      case params[:status]
      when "todo"
        @tasks = @tasks.where(completed: false)
      when "done"
        @tasks = @tasks.where(completed: true)
      else
      # すべて（何もしない）
      end


      # 🔍 検索
      if params[:keyword].present?
        keyword = "%#{params[:keyword]}%"

        base = current_user.tasks

        text_search = base.where(
          "title LIKE :kw OR description LIKE :kw",
          kw: keyword
        )

        status_search = case params[:keyword]
                  when "作業中"
                    base.where(status: "doing")
                  when "未着手"
                    base.where(status: "todo")
                  else
                    base.none
                  end

        @tasks = text_search.or(status_search)
      end
      

      # 🔽 並び替え + ページネーション
      @tasks = @tasks.order(:position)
               .page(params[:page]).per(6)
      
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
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tasks_path, notice: "更新しました" }
    end
  else
    render :edit
  end
end

    def destroy
      @task = current_user.tasks.find(params[:id])
      @task.destroy
      redirect_to root_path, notice: "削除しました"
    end


    def sort
  params[:ids].each_with_index do |id, index|
    current_user.tasks.find(id).update(position: index)
  end

  head :ok
end





    private

    def task_params
      params.require(:task).permit(:title, :description, :status, :team_id, :completed)
    end

end
