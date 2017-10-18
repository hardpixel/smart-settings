require 'tableless'

module SmartSettings
  class Setting < ActiveRecord::Base
    include Tableless
    include SmartSettings::Querying
  end
end
