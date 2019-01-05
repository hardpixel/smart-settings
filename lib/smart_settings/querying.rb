module SmartSettings
  module Querying
    extend ActiveSupport::Concern

    class_methods do
      def setting_class(var)
        "#{var}_settings".camelize
      end

      def find(*var)
        return find_by_var!(var.first) unless var.size > 1

        results = where(var: var)
        raise_record_not_found_exception!(var) if results.blank?
      end

      def find_by_var(var)
        setting = setting_class(var).safe_constantize
        setting.nil? ? nil : setting.new
      end

      def find_by_var!(var)
        setting = find_by_var(var)
        setting.nil? ? raise_record_not_found_exception!(var) : setting
      end

      def where(options = {})
        vars = Hash[options][:var]
        return all if vars.nil?

        classes = Array(vars).map { |var| setting_class(var).safe_constantize }
        classes.reject(&:nil?).map { |setting| setting.new  }
      end

      def all
        return new.all if setting_names.any?

        files = Dir.glob(Rails.root.join('app', 'settings', '*.rb'))
        files = files.map { |file| file.to_s.split('/').last.sub('_settings.rb', '') }

        where(var: files)
      end

      def method_missing(method, *args, &block)
        setting = find_by_var(method)
        setting.nil? ? super : setting
      end

      private

      def raise_record_not_found_exception!(ids)
        vars  = ids.is_a?(Array) ? "(#{ids.join(', ')})" : ids
        error = "Couldn't find Settings with var: #{vars}"

        raise ActiveRecord::RecordNotFound.new(error, 'Settings', 'var')
      end
    end
  end
end
