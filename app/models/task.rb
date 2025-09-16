class Task < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, class_name: 'User', optional: true
  
  belongs_to :parent, class_name: "Task", optional: true
  has_many :subtasks, class_name: "Task", foreign_key: "parent_id", dependent: :destroy
  
  has_many :predecessor_dependencies, class_name: "TaskDependency", foreign_key: "successor_id", dependent: :destroy
  has_many :successor_dependencies, class_name: "TaskDependency", foreign_key: "predecessor_id", dependent: :destroy
  has_many :predecessors, through: :predecessor_dependencies, source: :predecessor
  has_many :successors, through: :successor_dependencies, source: :successor
  
  enum :status, { not_started: 0, in_progress: 1, completed: 2, blocked: 3, cancelled: 4 }, default: :not_started, validate: true
  enum :priority, { low: 0, medium: 1, high: 2, urgent: 3 }, default: :medium, validate: true
  
  validates :title, presence: true
end
