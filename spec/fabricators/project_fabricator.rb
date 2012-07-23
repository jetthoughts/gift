Fabricator(:project) do
  name "MyString"
  description "MyString"
  article_link "http://google.com"
  participants_add_own_suggestions true
  paid_type :pay_pal
  deadline DateTime.now.advance(:days => 10)
end

Fabricator(:project_with_amount, from: :project) do
  name 'Project Name'
  end_type :fixed_amount
  fixed_amount 10
  paid_type :pay_pal
end
