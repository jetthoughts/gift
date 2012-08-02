class CloseProjectMailer < ActionMailer::Base
  default from: "from@example.com"

  def notify_user project, user
    @project = project
    mail(:to => user.email,
         :subject => "The project has been closed")
  end
end
