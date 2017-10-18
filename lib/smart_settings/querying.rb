module SmartSettings
  module Querying
    extend ActiveSupport::Concern

    class_methods do
      def setting_class(name)
        "#{name}_settings".camelize
      end

      def find(name)
        name.is_a?(Array) ? where(name: name) : find_by_name!(name)
      end

      def find_by_name(name)
        setting = setting_class(name).safe_constantize
        setting.new unless setting.nil?
      end

      def find_by_name!(name)
        setting = find_by_name(method)
        raise ActiveRecord::RecordNotFound if setting.nil?
      end

      def where(options={})
        names = Hash[options][:name]
        return all if names.nil?

        classes = Array(names).map { |name| setting_class(name).safe_constantize }
        classes.reject(&:nil?).map { |setting| setting.new  }
      end

      def all
        files = Dir.glob(Rails.root.join('app', 'settings', '*.rb'))
        files = files.map { |file| file.to_s.split('/').last.sub('_settings.rb', '') }

        where(name: files)
      end

      def method_missing(method, *args, &block)
        setting = find_by_name(method)
        setting.nil? ? super : setting
      end
    end
  end
end
