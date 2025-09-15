class TaskDependency < ApplicationRecord
  belongs_to :predecessor, class_name: 'Task'
  belongs_to :successor, class_name: 'Task'
  
  # Dependency types
  enum dependency_type: {
    finish_to_start: 0,    # Task B can't start until Task A finishes
    start_to_start: 1,     # Task B can't start until Task A starts
    finish_to_finish: 2,   # Task B can't finish until Task A finishes
    start_to_finish: 3     # Task B can't finish until Task A starts
  }
  
  validates :predecessor_id, presence: true
  validates :successor_id, presence: true
  validates :dependency_type, presence: true
  validate :no_self_dependency
  validate :no_circular_dependency
  
  private
  
  def no_self_dependency
    errors.add(:successor_id, "can't be the same as predecessor") if predecessor_id == successor_id
  end
  
  def no_circular_dependency
    # Basic circular dependency check - can be enhanced later
    if predecessor && successor
      errors.add(:base, "creates circular dependency") if creates_cycle?
    end
  end
  
  def creates_cycle?
    # Simple cycle detection - traverse successors to see if we reach the predecessor
    visited = Set.new
    queue = [successor_id]
    
    while queue.any?
      current_id = queue.shift
      return true if current_id == predecessor_id
      next if visited.include?(current_id)
      
      visited.add(current_id)
      
      # Add all successors of current task to queue
      TaskDependency.where(predecessor_id: current_id).pluck(:successor_id).each do |next_id|
        queue << next_id unless visited.include?(next_id)
      end
    end
    
    false
  end
end
