namespace :nimbleshop do

  desc "makes localhost available through a public url using localtunnel gem"
  task :localtunnel do
    exec "bundle exec localtunnel -k ~/.ssh/id_rsa.pub 3000"
  end

end
