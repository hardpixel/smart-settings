module SmartSettings
  module Models
    class Setting < ActiveRecord::Base
      self.table_name = 'settings'
    end
  end
end
