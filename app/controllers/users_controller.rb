class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_admin!, only: [:index]
  before_action :access_manage, only: [:show, :edit, :update]

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Profile was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def require_admin!
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end

  def access_manage
    unless @user == current_user || current_user.admin?
      redirect_to root_path, alert: "You do not have permission to do that."
    end
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
