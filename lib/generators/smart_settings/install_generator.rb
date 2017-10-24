require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module SmartSettings
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc 'Generates migrations to add settings tables.'
    source_root File.expand_path('../templates', __FILE__)

    def create_migration_file
      template 'model.rb', 'app/models/setting.rb'
      migration_template 'migration.rb', 'db/migrate/create_settings.rb'
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end
  end
end
