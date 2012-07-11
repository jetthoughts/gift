Fabricator(:project) do
  name "MyString"
  description "MyString"
  article_link "MyString"
  participants_add_own_suggestions false
  paid_type :pay_pal
end

Fabricator(:project_with_amount, from: :project) do
  name 'Project Name'
  end_type :fixed_amount
  fixed_amount 10
end
