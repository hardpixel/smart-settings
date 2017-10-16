require 'tableless'

module SmartSettings
  class Setting < ActiveRecord::Base
    include Tableless
  end
end
