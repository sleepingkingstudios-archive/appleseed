# lib/tasks/bootstrap.rake

namespace :appleseed do
  task :bootstrap => :environment do
    %w(
      settings
    ).each do |task|
      Rake::Task["appleseed:bootstrap:#{task}"].invoke
    end # each
  end # task

  namespace :bootstrap do
    task :settings => :environment do
      def create_setting name, type, value
        if Setting.where(:name => name).exists?
          setting = Setting.where(:name => name).first
          setting.update_attributes! :type => type, :value => value
        else
          Setting.create! :name => name, :type => type, :value => value
        end # if-else
      end # method create_setting

      create_setting 'title', 'String', nil

      # User Registration
      create_setting 'allow_user_registration?', 'Boolean', nil
    end # task
  end # namespace
end # namespace
