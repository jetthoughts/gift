module InvitesHelper
  def invite_ids project
    invites = []
    project.invites.each do |invite|
      invites << invite.fb_id unless invite.fb_id.blank?
    end
    invites
  end
end
