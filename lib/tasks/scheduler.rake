desc "This task is called by the cron"
task :check_project_deadline => :environment do
  puts "Check projects deadline..."
  now = DateTime.now
  Project.all.entries.each do |project|
    if !project.closed and project.deadline.present?
      remaining_time = project.deadline - now
      project.run_notify_about_deadline remaining_time
      project.close if remaining_time <= 0
    end
  end
  puts "done."
end