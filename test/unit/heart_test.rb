require 'test_helper'

class HeartTest < ActiveSupport::TestCase
  should "be valid" do
    assert Heart.new.valid?
  end
end
