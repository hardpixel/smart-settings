module SmartSettings
  module Querying
    extend ActiveSupport::Concern

    class_methods do
      def setting_class(name)
        "#{name}_settings".camelize
      end

      def find(*name)
        if name.size > 1
          results = where(name: name)
          raise_record_not_found_exception!(name) if results.blank?
        else
          find_by_name!(name.first)
        end
      end

      def find_by_name(name)
        setting = setting_class(name).safe_constantize
        setting.nil? ? nil : setting.new
      end

      def find_by_name!(name)
        setting = find_by_name(name)
        setting.nil? ? raise_record_not_found_exception!(name) : setting
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

      private

        def raise_record_not_found_exception!(ids)
          names = ids.is_a?(Array) ? "(#{ids.join(', ')})" : ids
          error = "Couldn't find Settings with name: #{names}"

          raise ActiveRecord::RecordNotFound.new(error, 'Settings', 'name')
        end
    end
  end
end
