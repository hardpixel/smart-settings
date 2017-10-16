require_relative 'no_table'

module SmartSettings
  class Setting < ActiveRecord::Base
    include SmartSettings::NoTable
  end
end
