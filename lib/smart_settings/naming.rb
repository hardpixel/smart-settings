module SmartSettings
  module Naming
    extend ActiveSupport::Concern

    included do
      attribute :var, :string
    end

    class_methods do
      def model_name
        ActiveModel::Name.new(Setting, nil, 'Setting')
      end
    end

    def var
      self.class.name.sub('Settings', '')
    end

    def to_param
      "#{var}".parameterize
    end
  end
end
