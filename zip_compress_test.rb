# -*- coding:utf-8 -*-

require 'test/unit'
require './zip_compress'

class TC_zip_compress < Test::Unit::TestCase
  #def setup
  #  @obj = Foo.new
  #end

  # def teardown
  # end

  def test_test
    assert_equal("test", test)
  end

  def test_compare1
    assert_equal(0, compare("a", "a"))
    assert_equal(1, compare("b", "a"))
    assert_equal(-1, compare("a", "b"))
    assert_equal(0, compare("1", "1"))
    assert_equal(-1, compare("1", "2"))
    assert_equal(1, compare("2", "1"))
    assert_equal(0, compare("111", "111"))
    assert_equal(0, compare("_", "_"))
    assert_equal(-1, compare("!", "_"))
    assert_equal(-1, compare("-.jpg", "1.jpg"))
    assert_equal(-1, compare("001.jpg", "01.jpg"))
    assert_equal(1, compare("001.jpg", "_001.jpg"))
    assert_equal(1, compare("001.jpg", "-001.jpg"))
    assert_equal(1, compare("001.jpg", "+001.jpg"))
    assert_equal(1, compare("001.jpg", "##001.jpg"))
    assert_equal(1, compare("001.jpg", "^001.jpg"))
    assert_equal(1, compare("001.jpg", ":001.jpg"))
    assert_equal(1, compare("001.jpg", "(001.jpg"))
    assert_equal(-1, compare("001.jpg", "a001.jpg"))
  end

  def testSort1()
    file_list = ['88.txt', '5.txt', '11.txt']
    sorted_list = sort(file_list)
    success_file_list = ['5.txt', '11.txt', '88.txt']
    assert_equal(success_file_list, sorted_list)
  end

  def testSort2()
    file_list = ['Ie5', 'Ie6', 'Ie4_01', 'Ie401sp2', 'Ie4_128', 'Ie501sp2']
    sorted_list = sort(file_list)
    success_file_list = ['Ie4_01', 'Ie4_128', 'Ie5', 'Ie6', 'Ie401sp2', 'Ie501sp2']
    assert_equal(success_file_list, sorted_list)
  end

end
