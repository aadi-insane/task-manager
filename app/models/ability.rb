class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action.
    # Other common actions here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details: https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    return unless user.present?
    
    if user.admin?
      can :manage, :all
    elsif user.manager?
      can :read, :all
      can :manage, Project, owner: user
      can :manage, Task do |task|
        task.project.owner == user
      end
      can :manage, TaskDependency do |dependency|
        dependency.predecessor.project.owner == user || dependency.successor.project.owner == user
      end
    elsif user.member?
      can :read, [Project, Task, TaskDependency]
      can [:update], Task, assignee: user
      can [:create], Task 
    end
  end
end
