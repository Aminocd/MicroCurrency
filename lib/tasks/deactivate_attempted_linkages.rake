namespace :rails_app do
  desc "check if any of the active attempted_linkages are older than the cutoff number of minutes and deactivate them"
  task deactivate_attempted_linkages: :environment do
    puts "deactivate every active attempted_linkage that is older than #{A.cutoff_minutes} minutes"
    AttemptedLinkage.deactivate_attempted_linkages_above_age_threshold
  end
end
