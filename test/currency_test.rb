require File.dirname(__FILE__) + '/test_helper'

class CurrencyTest < Test::Unit::TestCase
  include Multilingual
  fixtures :multilingual_languages, :multilingual_countries, :multilingual_translations

  def setup
    Locale.set("en-US")
  end

  def test_creation
     m = Currency.new(100)
     assert_equal 100, m.cents
  end

  def test_nil
    m = Currency.new(nil)
    assert_nil m.cents
  end

  def test_free
    m = Currency.free
    assert_equal 0, m.cents
  end

  def test_comparisons
    m1 = Currency.new(200)
    m2 = Currency.new(300)
    m3 = Currency.new(300)
    assert m1 != m2
    assert m1 == m1
    assert m2 == m3
    assert_equal -1, m1 <=> m2
    assert_equal 0, m2 <=> m3
    
    mn = Currency.new(nil)
    mn2 = Currency.new(nil)
    assert_equal mn, mn2
    assert_not_equal mn, m1
    assert mn > m1
    assert m1 < mn
    assert_equal 1, mn <=> m1
  end

  def test_math
    m1 = Currency.new(200)
    m2 = Currency.new(300)
    assert_equal 500, (m1 + m2).cents
    assert_equal 100, (m2 - m1).cents
    assert_equal 600, (m2 * 2).cents
    assert_equal 10, (m1 / 20).cents

    mn = Currency.new(nil)
    mn2 = Currency.new(nil)
    assert_equal mn, mn + mn2
    assert_equal mn, mn - mn2
    assert_equal mn, mn * 1000
    assert_equal mn, mn / 1000
  end

  def test_parse
    m1 = Currency.parse("$134.54")
    assert_equal 13454, m1.cents
    m2 = Currency.parse(134.587)
    assert_equal 13458, m2.cents
    assert_equal Currency.na, Currency.parse(nil)
    assert_raise(ArgumentError) { Currency.parse("") }
    assert_raise(ArgumentError) { Currency.parse("abc.de") }
  end

  def test_format
    m1 = Currency.new(1234567)
    assert_equal "12,345.67", m1.amount

    mn = Currency.new(nil)
    assert_nil mn.amount
    assert_equal "call for price", mn.format

    Locale.set("he-IL")
    assert_equal "12,345.67 ₪", m1.format
    assert_equal "12,345.67 ILS", m1.format(:code => true)
    assert_equal "12,345.67 USD", m1.format(:code => true, :country => Country.pick("US"))

    Locale.set("de-CH")
    assert_equal "SFr. 12'345.67", m1.format
    assert_equal "12'345.67 CHF", m1.format(:code => true)
    assert_equal "12'345.67 USD", m1.format(:code => true, :country => Country.pick("US"))

  end

end
