module SmartSettings
  module Naming
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
    end

    class_methods do
      def model_name
        ActiveModel::Name.new(Setting, nil, 'Setting')
      end
    end

    def name
      self.class.name.sub('Settings', '')
    end

    def to_param
      "#{name}".parameterize
    end
  end
end
