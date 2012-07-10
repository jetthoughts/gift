module ProjectsHelper
  def like_dislike_button card
    if current_user.voted? card
      submit_tag 'Dislike'
    else
      submit_tag 'Like'
    end
  end
end
