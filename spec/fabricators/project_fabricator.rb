Fabricator(:project) do
  name "MyString"
  description "MyString"
  article_link "http://google.com"
  participants_add_own_suggestions false
  paid_type :pay_pal
end
