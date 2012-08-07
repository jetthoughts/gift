class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      cannot :manage, :all
      can :create, User
      can :facebook_invite, User
    else
      cannot :manage, :all
      can :manage, Attachment
      can :create, Invite do |invite|
        !invite.project.closed
      end
      can [:show, :update, :destroy, :create_facebook, :find_invite, :facebook_update, :facebook_destroy], Invite, user_id: user.id
      can :show, Project do |project|
        user.projects.for_ids(project.id).exists?
      end
      can :close, Project, admin_id: user.id
      can [:edit, :update], Project do |project|
        !project.closed and project.admin == user
      end
      can [:show, :create, :new, :index], Project, admin_id: user.id

      can :manage, Comment do |comment|
        !comment.project.closed
      end
      can [:show], Comment do |comment|
        comment.project && comment.project.participant?(user)
      end
      can :manage, Withdraw
      can :manage, Fee
      can :manage, User, id: user.id
      can :create_facebook, User, id: user.id
      can [:new, :amazon_search, :fetch], Card
      can :create, Card do |card|
        card.project && card.project.participants_add_own_suggestions &&
            card.project.participant?(user) && !card.project.closed
      end
      can [:show, :update], Card do |card|
        card.project.participant?(user) && !card.project.closed
      end
      can :destroy, Card, user_id: user.id
    end
  end
end
