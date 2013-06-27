require_dependency 'time_entry_reports_controller' if File.exists?("#{Rails.root}/app/controllers/time_entry_reports_controller.rb")
require_dependency 'timelog_controller' if File.exists?("#{Rails.root}/app/controllers/timelog_controller.rb")

# Patches Redmine's TimeEntryReportsController dinamically. Adds an option "Role" to the list of available criterias
# for the time entries report
module CMI
  module TimeEntryReportsCommonPatch
#XXX: Does not work in Redmine 2.3 (gw0)
#    def self.included(base) # :nodoc:
#      base.extend(ClassMethods)
#      base.send(:include, InstanceMethods)
#
#      base.class_eval do
#        unloadable # Send unloadable so it will be reloaded in development
#        before_filter :load_profile_criteria, :only => [:report]
#      end
#    end
#
#    module ClassMethods
#    end
#
#    module InstanceMethods
#      def load_profile_criteria
#        @available_criterias['profile'] = {:sql => "Role",
#                                           :label => :label_profile}
#      end
#    end
  end
end

Rails.configuration.to_prepare do
  # For Redmine >= 1.1.0
  TimeEntryReportsController.send(:include, CMI::TimeEntryReportsCommonPatch) if File.exists?("#{Rails.root}/app/controllers/time_entry_reports_controller.rb")
  # For Redmine < 1.1.0
  TimelogController.send(:include, CMI::TimeEntryReportsCommonPatch) if File.exists?("#{Rails.root}/app/controllers/timelog_controller.rb")
end
