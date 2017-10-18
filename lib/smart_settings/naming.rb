module SmartSettings
  module Naming
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
    end

    def name
      self.class.name.sub('Settings', '')
    end

    def to_param
      name
    end
  end
end
