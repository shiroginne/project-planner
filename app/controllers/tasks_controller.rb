class TasksController < ApplicationController
  before_action :fetch_project
  before_action :fetch_task, only: [:edit, :update, :destroy]

  def create
    @task = @project.tasks.new(task_params)
    if @task.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend("tasks_for_project_#{@project.id}", partial: "tasks/task", locals: { task: @task })
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@task, partial: "tasks/task", locals: { task: @task })
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy!

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@task)
      end
    end
  end

  private

  def fetch_project
    @project = Project.find(params[:project_id])
  end

  def fetch_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :parent_id)
  end
end
