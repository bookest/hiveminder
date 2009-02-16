require 'test/unit'
require 'hiveminder'

class TaskTest < Test::Unit::TestCase
  def test_tags_are_expanded
    task = Hiveminder::Task.new(:tags => "\"@foo\" \"bar\" \"one two\"")
    assert_equal ["@foo", "bar", "one two"], task.tags
  end
end
