require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module SmartSettings
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    attr_accessor :template

    desc 'Generates migrations to add settings tables.'
    source_root File.expand_path('../templates', __FILE__)
    class_option :global, type: :boolean, default: false, desc: 'Add global settings table.'
    class_option :scoped, type: :boolean, default: false, desc: 'Add scoped settings table.'

    def create_migration_file
      add_smart_settings_migration('global') if options.global?
      add_smart_settings_migration('scoped') if options.scoped?
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    protected

      def add_smart_settings_migration(template)
        @template = template
        migration_template 'migration.rb', "db/migrate/create_#{template}_settings.rb"
      end
  end
end
