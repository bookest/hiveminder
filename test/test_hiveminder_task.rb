require 'test/unit'
require 'hiveminder'
require 'mocha'

class TaskTest < Test::Unit::TestCase
  def test_tags_are_expanded
    task = Hiveminder::Task.new(:tags => "\"@foo\" \"bar\" \"one two\"")
    assert_equal ["@foo", "bar", "one two"], task.tags
  end

  def test_tags_array_converted_to_string_on_save
    task = Hiveminder::Task.new
    task.stubs(:save_without_tags).returns(true)
    task.tags = ["@foo", "baz"]
    task.save
    assert_equal "\"@foo\" \"baz\"", task.attributes['tags']
  end
end
