require File.dirname(__FILE__) + '/test_helper'

class ViewPickingTest < Test::Unit::TestCase
  include Multilingual
  fixtures :multilingual_languages, :multilingual_countries

  class TestController < ActionView::Base
  end

  def setup
    Locale.set("en-US")
    @base_path = File.dirname(__FILE__) + '/views'
  end

  def test_first
    tc = TestController.new
    tc.base_path = @base_path
    assert_match /English/, tc.render("test")
    assert_no_match /Hebrew/, tc.render("test")
    Locale.set("he-IL")
    assert_match /Hebrew/, tc.render("test")
    assert_no_match /English/, tc.render("test")
  end

end
