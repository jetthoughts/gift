class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      cannot :manage, :all
      can :create, User
    else
      cannot :manage, :all

      can [:create, :update, :destroy], Invite, user_id: user.id
      can :show, Project do |project|
        user.projects.for_ids(project.id).exists?
      end
      can :manage, Project, admin_id: user.id
      can :manage, Comment,  user_id: user.id
      can :manage, User,          id: user.id

      can :create, Card do |card|
        card.project.participants_add_own_suggestions? &&
          card.project.users.for_ids(user.id).exists?
      end
      can [:destroy], Card, user_id: user.id
    end
  end
end
