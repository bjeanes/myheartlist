require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  should "be valid" do
    assert Item.new.valid?
  end
end
