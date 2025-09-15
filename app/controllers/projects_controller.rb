class ProjectsController < ApplicationController
  before_action :authenticate_user!
before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.admin?
      @projects = Project.all
    else
      @projects = Project.where(owner_id: current_user.id)
    end
  end

  def show
    # Assuming Project has_many :tasks
    @tasks = @project.tasks.includes(:assignee, :subtasks)
    # You can preload associations to optimize queries
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    @project.owner_id = current_user.id
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  # GET /projects/:id/edit
  def edit
  end

  # PATCH/PUT /projects/:id
  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /projects/:id
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully deleted.'
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
