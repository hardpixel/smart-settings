module SmartSettings
  module Persistence
    extend ActiveSupport::Concern

    included do
      after_initialize do
        self.var = var

        settings.try(:each) do |setting|
          svar, value = [setting.var, setting.value]
          send(:"#{svar}=", cast_setting_value(svar, value))
        end

        @_suspend_save_callbacks = true
        self.save
        @_suspend_save_callbacks = false
      end

      before_save do
        unless @_suspend_save_callbacks
          changes_to_save.each do |var, value|
            create_or_update_setting(var, value.last)
          end
        end
      end

      before_destroy do
        settings.destroy_all
      end
    end

    def settings
      if settings_table_exists?
        valid = self.attribute_names.reject { |i| i == 'var' }
        Setting.where(settable_type: self.class.name, settable_id: id, var: valid)
      end
    end

    private

    def cast_setting_value(var, value)
      self.class.attribute_types[var].cast(value)
    end

    def create_setting(var, value)
      parameters = { var: var, value: cast_setting_value(var, value) }
      Setting.create(parameters.merge(settable_type: self.class.name, settable_id: id))
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

    def settings_table_exists?
      ActiveRecord::Base.connection.table_exists? Setting.table_name
    end
  end
end
