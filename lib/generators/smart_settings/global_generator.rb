require 'rails/generators'
require 'rails/generators/migration'

module SmartSettings
  class GlobalGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc 'Generates migration for global settings'
    source_root File.expand_path('../templates', __FILE__)

    def create_migration_file
      migration_template 'global.rb', 'db/migrate/create_global_settings.rb'
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end
  end
end
