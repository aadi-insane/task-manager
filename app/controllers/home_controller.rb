class HomeController < ApplicationController
  def index
    if user_signed_in?
      if current_user.admin?
        @users = User.all.order(:id)
      elsif current_user.manager?
        @users = User.where(role: ['member', 'manager']).order(:id)
      else
        
      end
    else
      
    end
  end
end
