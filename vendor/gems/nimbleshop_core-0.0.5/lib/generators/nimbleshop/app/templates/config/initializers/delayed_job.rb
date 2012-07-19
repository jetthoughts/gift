# By default DJ deletes all the failed jobs after 25 attemps. Here DJ is being configured to not to delete
# the failed jobs. 
#
# By the way all the failed jobs can be cleared with rake task rake jobs:clear
Delayed::Worker.destroy_failed_jobs = false

Delayed::Worker.delay_jobs = !Rails.env.test?

# ============= ADDITIONAL NOTES ======================
#
# to start processing pending jobs using Delayed Job execute rake jobs:work
#
# access delayed_job_admin at http://localhost:3000/delayed_job_admin . See method delayed_job_admin_authentication in 
# application_controller.rb for authentication for delayed_job_admin

