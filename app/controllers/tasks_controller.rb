class TasksController < ApplicationController
    before_action :authenticate_user!


    def index
  @tasks = current_user.tasks

  # 🔽 フィルター（ここ修正）
  case params[:status]
  when "todo"
    @tasks = @tasks.where(status: ["todo", "doing"])
  when "done"
    @tasks = @tasks.where(status: "done")
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
    current_user.tasks.where.not(id: @task.id)
                .update_all("position = position + 1")

    @task.update(position: 1)

    # 👇 これ重要（再描画用）
    @tasks = current_user.tasks.order(:position)
                 .page(1).per(6)

    flash[:notice] = "作成しました"

    respond_to do |format|
      format.html { redirect_to tasks_path }
      format.turbo_stream
    end

    # 👇 ここが重要
@tasks.each do |task|
  if task.id == @task.id
    task.instance_variable_set(:@newly_created, true)
  end
end

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
    # 👇 これ追加
    @tasks = current_user.tasks.order(:position)
                 .page(params[:page]).per(6)

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

  # 👇 これが超重要
  @tasks = current_user.tasks.order(:position)
               .page(params[:page]).per(6)

  flash[:notice] = "削除しました"

  respond_to do |format|
    format.turbo_stream
    format.html { redirect_to tasks_path }
  end
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
