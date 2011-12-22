require 'test/unit'
require 'sort'

class TC_Foo < Test::Unit::TestCase
  #def setup
  #  @obj = Foo.new
  #end

  # def teardown
  # end

  def test_remove_redundant
    assert_equal(["a", "b"], remove_redundant("a", "b"))
    assert_equal(["", "b"], remove_redundant("a", "ab"))
    assert_equal(["b", ""], remove_redundant("ab", "a"))
    assert_equal(["", ""], remove_redundant("a", "a"))
    assert_equal(["", ""], remove_redundant("", ""))
    assert_equal(["abc", "def"], remove_redundant("abc", "def"))
    assert_equal(["bc", "ef"], remove_redundant("abc", "aef"))
    assert_equal(["5", "401sp2"], remove_redundant("Ie5", "Ie401sp2"))
    assert_equal(["401sp2", "4_01"], remove_redundant("Ie401sp2", "Ie4_01"))
  end

  def test_get_number
    assert_equal(1, get_number("1"))
    assert_equal(-1, get_number(""))
    assert_equal(-1, get_number("a"))
    assert_equal(-1, get_number("ab"))
    assert_equal(12345, get_number("12345"))
    assert_equal(12345, get_number("12345_122"))
    assert_equal(1234567890, get_number("1234567890"))
    assert_equal(-1, get_number("a1"))
    assert_equal(1, get_number("1a2"))
    assert_equal(401, get_number("401a2"))
    assert_equal(1, get_number("01sp2"))
    assert_equal(-1, get_number("_0"))
  end

  def test_compare
    assert_equal(0, compare("a", "a"))
    assert_equal(1, compare("b", "a"))
    assert_equal(-1, compare("a", "b"))
    assert_equal(0, compare("1", "1"))
    assert_equal(-1, compare("1", "2"))
    assert_equal(1, compare("2", "1"))
    assert_equal(0, compare("111", "111"))
    assert_equal(-1, compare("Ie5", "Ie401sp2"))
    assert_equal(1, compare("Ie5", "Ie4_128"))
    assert_equal(1, compare("Ie401sp2", "Ie4_01"))
  end

  def test_sort1
    file_list = ['88.txt', '5.txt', '11.txt']
    sorted_list = sort(file_list)
    success_file_list = ['5.txt', '11.txt', '88.txt']
    assert_equal(success_file_list, sorted_list)
  end

  def test_sort2
    file_list = ['Ie5', 'Ie6', 'Ie4_01', 'Ie401sp2', 'Ie4_128', 'Ie501sp2']
    sorted_list = sort(file_list)
    success_file_list = ['Ie4_01', 'Ie4_128', 'Ie5', 'Ie6', 'Ie401sp2', 'Ie501sp2']
    assert_equal(success_file_list, sorted_list)
  end

end