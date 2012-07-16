ActiveAdmin.register Card do
  index do
    column "Image" do |card|
      link_to(image_tag(card.image.url(:tiny_thumb)), card.web_link)
    end
    column :description
    column :price
    column :project
    column :user
    default_actions
  end

  form do |f|
    f.inputs "Card" do
      f.input :image
      f.input :description
      f.input :price
      f.input :project
      f.input :user
    end
    f.buttons
  end
end