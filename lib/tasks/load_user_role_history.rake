desc 'Load CMI user role history. (db/fixtures/history_user_profiles.csv)'

namespace :cmi do
  task :load_user_role_history => :environment do
    reader = File.open(File.join(%w[db fixtures], 'history_user_profiles.csv')).read

    reader.each_line do |line|
      if line != reader.lines.first
        hpc = line.split(",")
        HistoryProfilesCost.create(profile: hpc[2], user_id: hpc[1], created_on: hpc[3].to_date)
      end
    end

    User.find_each do |u|
      h = HistoryUserProfile.find(:first,
                                  :conditions => {:user_id => u.id},
                                  :order => 'created_on DESC')
      unless h.nil?
        u.role = h.profile
        u.save!
      end
    end
  end
end
