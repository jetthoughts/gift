class InvitesMailer < ActionMailer::Base
  default from: "from@example.com"

  def exist_user_notify(invite)
    @invite = invite
    mail(:to => @invite.email,
         :subject => "Invite you to new project")
  end

  def new_user_notify(invite)
    @invite = invite
    mail(:to => @invite.email,
         :subject => "Invite you to new project")
  end

end
