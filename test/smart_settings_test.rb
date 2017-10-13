require 'test_helper'

class SmartSettingsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SmartSettings::VERSION
  end
end
