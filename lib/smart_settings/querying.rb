module SmartSettings
  module Querying
    extend ActiveSupport::Concern

    class_methods do
      def setting_class(name)
        "#{name}_settings".camelize
      end

      def find(name)
        name.is_a?(Array) ? where(name: name) : find!(name)
      end

      def find!(name)
        setting_class(name).constantize.new
      rescue
        ActiveRecord::RecordNotFound
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
        setting = setting_class(method).safe_constantize
        setting.nil? ? super : setting.new
      end
    end
  end
end
