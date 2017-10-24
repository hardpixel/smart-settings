require 'rails/generators'

module SmartSettings
  class SettingGenerator < Rails::Generators::Base

    desc 'Generates a new setting class in settings folder.'
    source_root File.expand_path('../templates', __FILE__)

    argument :name, type: :string, required: true

    def create_migration_file
      template 'setting.rb', "app/settings/#{setting_file}.rb"
    end

    private

      def setting_class
        name.camelize
      end

      def setting_file
        "#{name.downcase.underscore}_settings"
      end

      def setting_fields
        args.map do |arg|
          field, cast_type, default, group = arg.split(':')

          items  = [":#{field.to_sym}", ":#{cast_type.to_sym}"]
          items << ["default: #{value_type_cast(cast_type.to_sym, default)}"] if default.present?
          items << ["group: :#{group.to_sym}"] if group.present?

          items.join(', ')
        end
      end

      def value_type_cast(cast_type, value)
        strings = [:string, :date, :datetime, :time]
        cast_type.in?(strings) ? "'#{value}'" : value
      end
  end
end
