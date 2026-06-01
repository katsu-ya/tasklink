class TasksController < ApplicationController
    before_action :authenticate_user!


    def index
  @tasks = current_user.tasks.includes(:team)

  @todo_count = current_user.tasks.where(status: "todo").count
  @doing_count = current_user.tasks.where(status: "doing").count
  @done_count = current_user.tasks.where(status: "done").count


  @total_tasks = current_user.tasks.count
@completed_tasks = current_user.tasks.where(status: "done").count

@progress =
  if @total_tasks.zero?
    0
  else
    ((@completed_tasks.to_f / @total_tasks) * 100).round
  end



  # 🔽 フィルター（ここ修正）
  case params[:status]
  when "todo"
    @tasks = @tasks.where(status: "todo")
  when "doing"
    @tasks = @tasks.where(status: "doing")
  when "done"
    @tasks = @tasks.where(status: "done")
  end



  # 🔍 検索
  if params[:keyword].present?
    keyword = "%#{params[:keyword]}%"

    base = @tasks

    text_search = base.where(
      "title LIKE :kw OR description LIKE :kw",
      kw: keyword
    )

    status_search = case params[:keyword]
    when "作業中"
                      base.where(status: "doing")
    when "未着手"
                      base.where(status: "todo")
    when "完了"
                      base.where(status: "done")

    else
                      base.none
    end

    @tasks = text_search.or(status_search)
  end


  @tasks = @tasks
  .order(created_at: :desc)
  .page(params[:page]).per(6)
end



    def new
      @task = Task.new
    end



    def create
  @task = current_user.tasks.new(task_params)

  if @task.save
    tasks = current_user.tasks

    tasks.where.not(id: @task.id)
         .update_all("position = position + 1")

    @task.update(position: 1)

    @tasks = tasks
               .order(created_at: :desc)
               .page(1).per(6)

    flash[:notice] = "作成しました"

    @todo_count = tasks.where(status: "todo").count
    @doing_count = tasks.where(status: "doing").count
    @done_count = tasks.where(status: "done").count

    @total_tasks = tasks.count
    @completed_tasks = tasks.where(status: "done").count

    @progress =
      ((@completed_tasks.to_f / @total_tasks) * 100).round

    respond_to do |format|
      format.html { redirect_to tasks_path }
      format.turbo_stream
    end

    @tasks.each do |task|
      if task.id == @task.id
        task.instance_variable_set(:@newly_created, true)
      end
    end
  else
    render :new
  end
end

    def show
      @task = current_user.tasks.find(params[:id])
    end


    def edit
      @task = current_user.tasks.find(params[:id])
    end



    def update
  @task = current_user.tasks.find(params[:id])

  if @task.update(task_params)

    flash.now[:notice] = case @task.status
    when "todo"
      "未着手に戻しました 📝"
    when "doing"
      "作業中にしました 🔥"
    when "done"
      "タスク完了！ 🎉"
    end

    @tasks = current_user.tasks
                         .order(created_at: :desc)
                         .page(params[:page]).per(6)

    @todo_count = current_user.tasks.where(status: "todo").count
    @doing_count = current_user.tasks.where(status: "doing").count
    @done_count = current_user.tasks.where(status: "done").count

    @total_tasks = current_user.tasks.count
    @completed_tasks = current_user.tasks.where(status: "done").count

    @progress =
      if @total_tasks.zero?
        0
      else
        ((@completed_tasks.to_f / @total_tasks) * 100).round
      end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tasks_path, notice: "更新しました" }
    end

  else
    render :edit, status: :unprocessable_entity
  end
end


    def destroy
  @task = current_user.tasks.find(params[:id])
  @task.destroy

  # 👇 これが超重要
  @tasks = current_user.tasks.order(created_at: :desc)
               .page(params[:page]).per(6)

  flash[:notice] = "削除しました"

  @todo_count = current_user.tasks.where(status: "todo").count
      @doing_count = current_user.tasks.where(status: "doing").count
      @done_count = current_user.tasks.where(status: "done").count

      @total_tasks = current_user.tasks.count
      @completed_tasks = current_user.tasks.where(status: "done").count

    @progress =
  if @total_tasks.zero?
    0
  else
    ((@completed_tasks.to_f / @total_tasks) * 100).round
  end


  respond_to do |format|
    format.turbo_stream
    format.html { redirect_to tasks_path }
  end
end



  def reorder
    params[:ids].each_with_index do |id, index|
      current_user.tasks.find(id).update(position: index + 1)
    end

  head :ok
end


    private

    def task_params
      params.require(:task).permit(:title, :description, :status, :team_id, :completed, :deadline)
    end
end
