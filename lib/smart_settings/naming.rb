module SmartSettings
  module Naming
    extend ActiveSupport::Concern

    included do
      attribute :var, :string
    end

    class_methods do
      def model_name
        ActiveModel::Name.new(self, nil, 'Setting')
      end

      def permitted_attributes
        attribute_names
      end
    end

    def var
      self.class.name.to_s.demodulize.sub('Settings', '')
    end

    def to_param
      var.to_s.parameterize
    end

    def permitted_attributes
      attribute_names - ['var']
    end
  end
end
