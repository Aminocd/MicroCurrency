namespace :rails_app do
  desc "check if any of the active attempted_reallocations are older than the cutoff number of minutes and deactivate them"
  task deactivate_attempted_reallocations: :environment do
    puts "deactivate every active attempted_reallocation that is older than #{A.cutoff_minutes} minutes"
    AttemptedReallocation.deactivate_attempted_reallocations_above_age_threshold
  end
end
