class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:create, :new]
  before_action :set_task, only: [:edit, :show, :update, :destroy]

  def index
    if current_user.member?
      @tasks = Task.where(assignee_id: current_user.id)
    end
  end

  def new
    @task = @project.tasks.build
  end

  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.new(task_params)
    @task.starts_at = Date.today
    
    if @task.save
      redirect_to project_task_path(@project, @task), notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_content
      flash.now[:alert] = "Something went wrong!"
    end

    #https://www.reddit.com/r/rails/comments/zb1ht5/rails_7_link_to_using_turbo_stream_rather_than/

    # respond_to do |format|
    #   if @task.save
    #     format.turbo_stream { redirect_to project_task_path(@project, @task), notice: "Task was successfully created.", status: :see_other }
    #     format.html { redirect_to project_task_path(@project, @task), notice: "Task was successfully created." }
    #   else
    #     format.turbo_stream { render turbo_stream: turbo_stream.replace(@task, partial: "tasks/form", locals: { project: @project, task: @task }), status: :unprocessable_entity }
    #     format.html { render :new, status: :unprocessable_entity }
    #   end
    # end
  end

  def show
    if current_user.admin?
      @tasks = Task.where(project_id: params[:id])
    else
      @tasks = Task.where(project_id: params[:id]).includes(:assignee)
    end
  end

  def edit
    @project = @task.project
  end

  def update
    if @task.update(task_params)
      redirect_to project_task_path(@task.project, @task), notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    project = @task.project
    @task.destroy
    redirect_to project_path(project), notice: "Task was successfully deleted."
  end

  private
  
    def set_task
      @task = Task.find(params[:id])
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :assignee_id, :priority, :due_at)
    end
end
