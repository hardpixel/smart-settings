module SmartSettings
  module Querying
    extend ActiveSupport::Concern

    class_methods do
      def find(name)
        "#{name}_settings".classify.constantize
      rescue
        ActiveRecord::RecordNotFound
      end
    end
  end
end
