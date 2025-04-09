class ProjectsController < ApplicationController
  def index
    @pagy, @projects = pagy(Project.order(:name), items: 20)
  end

  def show
    @project = Project.find(params[:id])
    @filter = params[:filter] || "active"
    @tasks = TaskQuery.new(project: @project, filter: @filter).call
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to projects_path, notice: "Project created"
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy!

    redirect_to projects_path, notice: "Project deleted"
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
