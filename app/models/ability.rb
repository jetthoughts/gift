class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      cannot :manage, :all
      can :create, User
    else
      cannot :manage, :all

      can :create, Invite
      can [:update, :destroy], Invite, user_id: user.id
      can :show, Project do |project|
        user.projects.for_ids(project.id).exists?
      end
      can :close, Project,  admin_id: user.id
      can :manage, Project, admin_id: user.id
      can :manage, Comment,  user_id: user.id
      can :create, Comment do |comment|
        comment.project && comment.project.participant?(user)
      end
      can :manage, Fee
      can :manage, User, id: user.id
      can :new, Card
      can :create, Card do |card|
        card.project && card.project.participants_add_own_suggestions &&
          card.project.participant?(user)
      end
      can [:show, :update], Card do |card|
        card.project.participant?(user)
      end
      can :destroy, Card, user_id: user.id
    end
  end
end
