module SmartSettings
  module Attributes
    extend ActiveSupport::Concern

    included do
      class_attribute :setting_names
      class_attribute :setting_group_names

      self.setting_names       = []
      self.setting_group_names = {}
    end

    class_methods do
      def setting(name, type_cast=:string, options={})
        gname = options.delete(:group)
        sname = gname.nil? ? name : :"#{gname}_#{name}"
        group = setting_group_names.fetch(gname, []) + [sname]

        attribute sname, type_cast, options

        self.setting_names      += sname
        self.setting_group_names = setting_group_names.merge(gname => group)
      end
    end

    def group_exists?(name)
      setting_group_names.keys.include? name
    end

    def group(name)
      if group_exists?(name)
        keys = setting_group_names[name]
        data = attributes.symbolize_keys.select { |k, _v| k.in? keys }

        Hash[data.map { |k, v| [k.to_s.sub("#{name}_", '').to_sym, v] }]
      end
    end

    def method_missing(method, *args, &block)
      group_exists?(method) ? group(method) : super
    end
  end
end
