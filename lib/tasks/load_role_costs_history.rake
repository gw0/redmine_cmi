desc 'Load CMI role costs history. (db/fixtures/history_profiles_costs.csv)'

namespace :cmi do
  task :load_role_costs_history => :environment do
    reader = File.open(File.join(%w[plugins redmine_cmi db fixtures], 'history_profiles_costs.csv')).read

    reader.each_line do |line|
      if line != reader.lines.first
        hpc = line.split(",")
        HistoryProfilesCost.create(profile: hpc[2], year: hpc[1], value: hpc[3].to_f)
      end
    end
  end
end
