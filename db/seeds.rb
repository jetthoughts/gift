# -*- coding: utf-8 -*-

user = User.create! email: 'user@gift.com', password: 'qweasd', name: 'User', confirmed_at: Time.now
AdminUser.create :email => 'admin@gift.com', :password => 'qweasd', :password_confirmation => 'qweasd'

def seed_image(file_name)
  File.open(File.join(Rails.root, "/db/assets/images/#{file_name}.jpg"))
end

project_image = Attachment.create! image: seed_image('project1')

project = Project.new name: 'New chessboard for our office', description: "Chess is a two-player board game played on a chessboard, a square checkered board with 64 squares arranged in an eight-by-eight grid. It is one of the world's most popular games, played by millions of people worldwide.",
                      participants_add_own_suggestions: true, deadline: 2.months.from_now,
                      end_type: 'open_end', paid_type: 'pay_pal', attachment_id: project_image.id

project.admin = user
project.users << user
project.save!

user.projects << project
user.save!


Card.create! name: 'Super Mario Chess',
             web_link: 'http://www.amazon.com/USAopoly-CH005-191-Super-Mario-Chess/dp/B00168PI9S/ref=sr_1_15?ie=UTF8&qid=1344242107&sr=8-15&keywords=chess+board',
             image: seed_image('gift1_1'), project_id: project.id, user: user.id, price: 36.33

Card.create! name: 'Royal 30 European Wood International Chess Set',
             web_link: 'http://www.amazon.com/Royal-European-Wood-International-Chess/dp/B0010FF1DK/ref=sr_1_8?ie=UTF8&qid=1344242107&sr=8-8&keywords=chess+board',
             image: seed_image('gift1_2'), project_id: project.id, user: user.id, price: 26.99

Card.create! name: 'Medieval Chess Set',
             web_link: 'http://www.amazon.com/Furniture-Creations-35301-Medieval-Chess/dp/B000NU2ZDW/ref=sr_1_5?ie=UTF8&qid=1344242107&sr=8-5&keywords=chess+board',
             image: seed_image('gift1_3'), project_id: project.id, user: user.id, price: 51.95


#project2
project_image = Attachment.create! image: seed_image('project2')

project = Project.new name: 'Office chair for our chairman', description: "Our company's founders are unhappy with the chairs in our office. Let's help them to choose the right model in a right shop.",
                      participants_add_own_suggestions: true, deadline: 2.months.from_now,
                      end_type: 'open_end', paid_type: 'pay_pal', attachment_id: project_image.id

project.admin = user
project.users << user
project.save!

user.projects << project
user.save!


Card.create! name: 'HON Resolution 6200 Series Low-Back Swivel and Tilt Chair',
             web_link: 'http://www.amazon.com/HON-6213BW69T-Resolution-Low-Back-Burgundy/dp/B0006NIFCG/ref=sr_1_40?s=home-garden&ie=UTF8&qid=1344245828&sr=1-40&keywords=desk+chair',
             image: seed_image('gift2_1'), project_id: project.id, user: user.id, price: 489

Card.create! name: 'Tiffany Industries ULEXBUR High-Back Swivel/Tilt Chair, Gunmetal Aluminum Base, Burgundy Leather',
             web_link: 'http://www.amazon.com/Tiffany-Industries-ULEXBUR-High-Back-Gunmetal/dp/B001MS6YL8/ref=sr_1_32?s=home-garden&ie=UTF8&qid=1344245828&sr=1-32&keywords=desk+chair',
             image: seed_image('gift2_2'), project_id: project.id, user: user.id, price: 609.74

Card.create! name: 'Hon Ignition Task Chair',
             web_link: 'http://www.amazon.com/Hon-Ignition-Task-Chair-Burgundy/dp/B0030GBUHS/ref=sr_1_19?s=home-garden&ie=UTF8&qid=1344245797&sr=1-19&keywords=desk+chair',
             image: seed_image('gift2_3'), project_id: project.id, user: user.id, price: 238
