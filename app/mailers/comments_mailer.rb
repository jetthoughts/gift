class CommentsMailer < ActionMailer::Base
  default from: "from@example.com"

  helper :projects

  def new_comment(comment, user)
    @comment = comment
    @user = user
    mail(:to => @user.email,
         :subject => "New comment")
  end

  def new_donation(fee, user)
    @fee = fee
    @user = user
    mail(:to => @user.email,
         :subject => "New donation")
  end

end
