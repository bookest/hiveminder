require 'test/unit'
require 'hiveminder'
require 'mocha'
require 'active_resource/http_mock'

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

  def test_locator
    task = Hiveminder::Task.new(:id => "12354")
    assert_equal task.locator, "F44"
  end
end

class BraindumpTest < Test::Unit::TestCase
  def setup
    @task1 = { :id => 1, :summary => "foo", :tags => "\"@test\""}
    @task2 = { :id => 2, :summary => "bar", :tags => "\"@test\""}

    Hiveminder.sid = "123"
    @headers = Hiveminder::Task.headers
  end

  def test_braindump_single_task
    data = { :success => "1", :content => { :created => @task1 }, }.to_xml(:root => :data)
    ActiveResource::HttpMock.respond_to do |mock|
      mock.post "/=/action/ParseTasksMagically.xml", @headers, data, 200
    end

    tasks = Hiveminder::Task.braindump(@task1[:summary])

    assert_equal tasks.length, 1
    assert_equal tasks.first.summary, @task1[:summary]
  end

  def test_braindump_multiple_tasks
    data = { :success => "1", :content => { :created => [ @task1, @task2 ] }, }.to_xml(:root => :data)
    ActiveResource::HttpMock.respond_to do |mock|
      mock.post "/=/action/ParseTasksMagically.xml", @headers, data, 200
    end

    tasks = Hiveminder::Task.braindump(@task1[:summary], @task2[:summary])

    assert_equal tasks.length, 2
    assert_equal tasks[0].summary, @task1[:summary]
    assert_equal tasks[1].summary, @task2[:summary]
  end

  def test_braindump_returns_nil_on_error
    data = { :success => "0", :content => { } }.to_xml(:root => :data)
    ActiveResource::HttpMock.respond_to do |mock|
      mock.post "/=/action/ParseTasksMagically.xml", @headers, data, 200
    end

    assert Hiveminder::Task.braindump(@task1[:summary]).nil?
  end
end
