if Rails.env.development?
  require 'guard/jasmine/task'

  desc "Run the code examples in spec/javascript"
  Guard::JasmineTask.new :jasmine, "-s unicorn"

  desc "Run the code examples in spec/javascript without server"
  Guard::JasmineTask.new :jasmine_serverless, "-s none"

  desc "Run RSpec and Jasmine specs"
  task full_spec: [:spec, :"guard:jasmine"]
end
