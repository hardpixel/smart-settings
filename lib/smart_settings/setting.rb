require 'active_record'

module SmartSettings
  class Setting < ActiveRecord::Base
    self.table_name = 'settings'
  end
end
