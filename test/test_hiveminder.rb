require 'test/unit'
require 'hiveminder'

class BaseTest < Test::Unit::TestCase
  class Foo < Hiveminder::Base
    self.collection_name = "Foo"
  end

  def test_element_path
    assert_equal '/=/model/Foo/id/1.xml', Foo.element_path(1)
  end

  def test_collection_path
    assert_equal "/=/search/Foo/__order_by/id.xml", Foo.collection_path
  end

  def test_collection_path_with_query_options
    query = { :complete => 0 }
    assert_equal "/=/search/Foo/__order_by/id/complete/0.xml", Foo.collection_path({ }, query)
  end

  def test_query_string
    assert_equal "/foo/bar/flim/flam", Foo.query_string({ :foo => :bar, :flim => :flam })
  end

  def test_instantiate_collection
    collection = %w(ping pong).collect { |e| { "value" => { "foo" => e }} }

    resources = Foo.instantiate_collection(collection)
    assert_equal 2, resources.length
    resources.each_with_index do |r, i|
      assert_kind_of Foo, r
      assert_respond_to r, :foo
      assert_equal collection[i]["value"]["foo"], r.foo
    end
  end

  def test_instantiate_collection_should_handle_single_values
    collection = { "value" => { "foo" => "bar" }}
    resources = Foo.instantiate_collection(collection)
    assert_equal 1, resources.length
    r = resources.first
    assert_kind_of Foo, r
    assert_respond_to r, :foo
    assert_equal "bar", r.foo
  end

  def test_hiveminder_cookie_is_set
    Foo.sid = "123"
    cookie = CGI::Cookie.parse(Foo.headers['Cookie'])

    assert cookie.include?('JIFTY_SID_HIVEMINDER')
    assert_equal 1, cookie['JIFTY_SID_HIVEMINDER'].length
    assert_equal "123", cookie['JIFTY_SID_HIVEMINDER'].first
  end
end

