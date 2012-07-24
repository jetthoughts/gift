Fabricator(:user) do
  email { Faker::Internet.email }
  password "password"
  name 'Max'
end