class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :owned_projects, class_name: 'Project', foreign_key: 'owner_id', dependent: :destroy
  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'assignee_id', dependent: :nullify
  
  enum role: { admin: 0, manager: 1, member: 2 }
  
  after_initialize :set_defaults, if: :new_record?
  
  private
    def set_defaults
      self.role ||= :member
      self.time_zone ||= 'UTC'
    end
end
