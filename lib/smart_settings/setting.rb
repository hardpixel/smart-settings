require 'tableless'

module SmartSettings
  class Setting < ActiveRecord::Base
    include Tableless
    include SmartSettings::Naming
    include SmartSettings::Querying
    include SmartSettings::Persistence
  end
end
