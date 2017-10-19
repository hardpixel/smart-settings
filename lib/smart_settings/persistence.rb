module SmartSettings
  module Persistence
    extend ActiveSupport::Concern

    included do
      after_initialize do
        settings.each do |setting|
          var, value = [setting.var, setting.value]
          send(:"#{var}=", cast_value(var, value))
        end

        save
      end

      before_update do
        updated = attributes.select { |k, _v| attribute_changed? k }

        updated.each do |var, value|
          create_or_update_setting(var, value)
        end
      end

      before_destroy do
        settings.destroy_all
      end
    end

    def settings
      SmartSettings::Models::Setting.where(settable_type: self.class.name)
    end

    private

      def cast_value(var, value)
        self.class.attribute_types[var].cast(value)
      end

      def create_setting(var, value)
        parameters = { settable_type: self.class.name, var: var, value: cast_value(var, value) }
        SmartSettings::Models::Setting.create(parameters)
      end

      def update_setting(var, value)
        settings.where(var: var).update(value: cast_value(var, value))
      end

      def create_or_update_setting(var, value)
        setting = settings.where(var: var)

        if setting.exists?
          update_setting(var, value)
        else
          create_setting(var, value)
        end
      end
  end
end
