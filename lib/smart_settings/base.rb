require 'tableless'

module SmartSettings
  class Base < ActiveRecord::Base
    include Tableless

    include SmartSettings::Naming
    include SmartSettings::Attributes
    include SmartSettings::Querying
    include SmartSettings::Persistence
  end
end
