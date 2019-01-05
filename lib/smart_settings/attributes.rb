module SmartSettings
  module Attributes
    extend ActiveSupport::Concern

    included do
      class_attribute :setting_names
      class_attribute :setting_groups

      self.setting_names  = []
      self.setting_groups = {}
    end

    class_methods do
      def setting(name, type_cast=:string, options={})
        gname = options.delete(:group)
        sname = gname.nil? ? name : :"#{gname}_#{name}"

        attribute sname, type_cast, options
        self.setting_names += [sname]

        return if gname.nil?

        group = setting_groups.fetch(gname, []) + [sname]
        self.setting_groups = setting_groups.merge(gname => group)
      end

      def method_missing(method, *args, &block)
        setting_names.any? ? new.send(method, *args, &block) : super
      end
    end

    def all
      except = setting_groups.values.flatten + [:var]
      single = attributes.symbolize_keys.except(*except)
      groups = Hash[setting_groups.keys.map { |s| [s, group(s)] }]

      single.merge(groups)
    end

    def group_exists?(name)
      setting_groups.keys.include? name
    end

    def group(name)
      return unless group_exists?(name)

      keys = setting_groups[name]
      data = attributes.symbolize_keys.select { |k, _v| k.in? keys }

      Hash[data.map { |k, v| [k.to_s.sub("#{name}_", '').to_sym, v] }]
    end

    def method_missing(method, *args, &block)
      group_exists?(method) ? group(method) : super
    end
  end
end
