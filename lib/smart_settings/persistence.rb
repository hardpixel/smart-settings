module SmartSettings
  module Persistence
    extend ActiveSupport::Concern

    included do
      after_initialize do
        self.var = var

        settings.each do |setting|
          svar, value = [setting.var, setting.value]
          send(:"#{svar}=", cast_setting_value(svar, value))
        end

        self.save
      end

      before_update do
        changes_to_save.each do |var, value|
          create_or_update_setting(var, value.last)
        end
      end

      before_destroy do
        settings.destroy_all
      end
    end

    def settings
      Models::Setting.where(settable_type: self.class.name)
    end

    private

      def cast_setting_value(var, value)
        self.class.attribute_types[var].cast(value)
      end

      def create_setting(var, value)
        parameters = { var: var, value: cast_setting_value(var, value) }
        Models::Setting.create(parameters.merge(settable_type: self.class.name))
      end

      def update_setting(var, value)
        settings.where(var: var).update(value: cast_setting_value(var, value))
      end

      def create_or_update_setting(var, value)
        if settings.where(var: var).exists?
          update_setting(var, value)
        else
          create_setting(var, value)
        end
      end
  end
end
