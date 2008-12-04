require 'test/unit'
require 'hiveminder/locator'

class LocatorTest < Test::Unit::TestCase
  def test_encode
    assert_equal 'F44', Hiveminder::Locator.encode(12354)
    assert_equal '5RL2', Hiveminder::Locator.encode(123456)
  end

  def test_encode_should_barf_on_non_integer
    assert_raise ArgumentError do
      Hiveminder::Locator.encode("123")
    end
  end

  def test_decode
    assert_equal 12354, Hiveminder::Locator.decode('F44')
    assert_equal 123456, Hiveminder::Locator.decode('5RL2')
  end

  def test_decode_should_barf_on_invalid_char
    assert_raise ArgumentError do
      Hiveminder::Locator.decode('12,3A')
    end
  end

  def test_decode_is_not_case_sensitive
    assert_equal Hiveminder::Locator.decode('ABC'), Hiveminder::Locator.decode('abc')
  end

  def test_round_trip
    assert_equal 1234, Hiveminder::Locator.decode(Hiveminder::Locator.encode(1234))
  end

  def test_remap
    assert_equal Hiveminder::Locator.decode('1234'), Hiveminder::Locator.decode('I234')
    assert_equal Hiveminder::Locator.decode('10SB'), Hiveminder::Locator.decode('IOFP')
  end
end
