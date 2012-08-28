desc "This task is called by the Heroku scheduler add-on"
task :check_project_deadline => :environment do
    puts "Check projects deadline..."
    now = Time.now
    Project.all.entries.each do |project|
      unless project.closed
        remaining_time = project.deadline - now
        project.run_notify_about_deadline remaining_time
        project.close true if remaining_time <= 0
      end
    end
    puts "done."
end