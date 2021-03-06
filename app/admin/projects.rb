ActiveAdmin.register Project do
  index do
    column :image do |project|
      image_tag(project.image.url(:tiny_thumb))
    end
    column :name
    column :description
    column :article_link
    column :participants_add_own_suggestions
    column :fixed_amount
    column :deadline
    column :paid_type
    column :end_type
    column :admin
    default_actions
  end

  action_item :only => [:show, :all_logs] do
    link_to 'Payment Logs', payment_logs_admin_project_path(resource)
  end

  action_item :only => :payment_logs do
    link_to 'All Logs', all_logs_admin_project_path(resource)
  end

  member_action :payment_logs do
    project = Project.find(params[:id])
    update_notifications = project.update_notifications.admin_events
    render :file => 'projects/_update_notifications', :locals => {update_notifications: update_notifications}
  end

  member_action :all_logs do
    project = Project.find(params[:id])
    update_notifications = project.update_notifications
    render :file => 'projects/_update_notifications', :locals => {update_notifications: update_notifications}
  end

  form do |f|
    f.inputs "Project" do
      f.input :name
      f.input :description
      f.input :article_link
      f.input :participants_add_own_suggestions, as: :check_boxes, collection: %w(Yes)
      f.input :fixed_amount
      f.input :deadline, :as => :datepicker
      f.input :paid_type, as: :radio, collection: Project::PAID_TYPES
      f.input :end_type, as: :radio, collection: Project::END_TYPES
      f.input :admin
      f.input :image
    end
    f.buttons
  end
end