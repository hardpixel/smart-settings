require 'tableless'

module SmartSettings
  class Setting < ActiveRecord::Base
    include Tableless
    include SmartSettings::Naming
    include SmartSettings::Querying
  end
end
