class DeadlineMailer < ActionMailer::Base
  default from: "from@example.com"

  def setup_mail project, user
    @project = project
    mail(to: user.email, subject: @subject)
  end

  def notify_owner project, user
    setup_mail project, user
  end

  def notify_one_day_owner project, user
    setup_mail project, user
  end

  def notify_one_day_members project, user
    setup_mail project, user
  end
end
