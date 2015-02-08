class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.create(task_params)

    if @task.save
      redirect_to tasks_path
    else
      render 'new'
    end
  end

  private
    def task_params
      params.require(:task).permit(:name, :goal, :description, :due_date, :completed, :priority)
    end
end
