class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      cannot :manage, :all
      can :create, User
      can :facebook_invite, User
    else
      cannot :manage, :all

      can :create, Invite
      can [:show, :update, :destroy, :create_facebook], Invite, user_id: user.id
      can :show, Project do |project|
        user.projects.for_ids(project.id).exists?
      end
      can :close, Project,  admin_id: user.id
      can :manage, Project, admin_id: user.id
      can :manage, Comment,  user_id: user.id
      can [:show, :create], Comment do |comment|
        comment.project && comment.project.participant?(user)
      end
      can :manage,  Withdraw
      can :manage, Fee
      can :manage, User, id: user.id
      can :create_facebook, User, id: user.id
      can :new, Card
      can :create, Card do |card|
        card.project && card.project.participants_add_own_suggestions &&
          card.project.participant?(user)
      end
      can :new, Card
      can [:show, :update], Card do |card|
        card.project.participant?(user)
      end
      can :destroy, Card, user_id: user.id
    end
  end
end
