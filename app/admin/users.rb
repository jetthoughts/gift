ActiveAdmin.register User do
  index do
    column :avatar do |user|
      image_tag(user.avatar.url(:tiny_thumb))
    end
    column :email
    column :name
    column :provider
    default_actions
  end

  form do |f|
    f.inputs "Users" do
      f.input :email
      f.input :name
      f.input :avatar
    end
    f.buttons
  end
end