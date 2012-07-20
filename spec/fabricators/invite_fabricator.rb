Fabricator(:invite) do
  email { Faker::Internet.email }
  name  { Faker::Name.name }
end

