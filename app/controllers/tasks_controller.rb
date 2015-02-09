class TasksController < ApplicationController
  before_filter :set_task, only: [:show, :edit, :update, :destroy, :complete]

  def index
    @tasks = Task.main
    @sub_tasks = Task.not_main
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_path
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update_attributes(task_params)
      redirect_to tasks_path
    else
      render 'edit'
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path
  end

  def complete
    @task.complete
    redirect_to tasks_path
  end

  private
    def task_params
      params.require(:task).permit(:name, :goal, :description, :due_date, :completed, :priority, :task_id, :recurring, :remind_me, :period)
    end

    def set_task
      @task = Task.find(params[:id])
    end
end
