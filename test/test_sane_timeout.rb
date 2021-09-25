require 'test/unit'
require_relative '../lib/sane_timeout.rb'
require 'thread'

class TestTimeout < Test::Unit::TestCase

  ### Tests that come with standard lib
  def test_queue
    q = Queue.new
    assert_raise(Timeout::Error, "[ruby-dev:32935]") {
      timeout(0.1) { q.pop }
    }
  end

  def test_timeout
    @flag = true
    Thread.start {
      sleep 0.1
      @flag = false
    }
    assert_nothing_raised("[ruby-dev:38319]") do
      Timeout.timeout(1) {
        nil while @flag
      }
    end
    assert !@flag, "[ruby-dev:38319]"
  end

  def test_cannot_convert_into_time_interval
    bug3168 = '[ruby-dev:41010]'
    def (n = Object.new).zero?; false; end
    assert_raise(TypeError, bug3168) {Timeout.timeout(n) { sleep 0.1 }}
  end



  ### tests not included in standard lib, but which standard lib does pass

  def test_non_timing_out_code_is_successful
    assert_nothing_raised do
      Timeout.timeout(2) {
        true
      }
    end
  end

  def test_code_that_takes_too_long_is_stopped_and_raises
    assert_raise(Timeout::Error) do
      Timeout.timeout(0.1) {
        sleep 10
      }
    end
  end

  def test_returns_block_value_when_not_timing_out
    retval = Timeout.timeout(1){ "foobar" }
    assert_equal "foobar", retval
  end


  ### Tests that sane_timeout passes

  require_relative 'error_lifecycle.rb'

  def expectations
    assert $inner_attempted,  "Inner was not attempted"
    assert !$inner_succeeded, "Inner did not succeed"
    assert !$caught_in_inner, "Exception was caught in inner"
    assert $inner_ensure, "Inner ensure was not reached"
    assert $raised_in_outer,  "Exception was not raised in outer"
    assert $outer_ensure, "Outer ensure succeeded"
    assert !$not_raised_in_outer, "Exception was not raised in outer(2)"
  end

  # when an exception to raise is not specified and the inner code does not catch Exception
  def test_1
    subject(nil, StandardError)
    expectations
  end

  # when an exception to raise is not specified and the inner code does catch Exception
  def test_2
    subject(nil, Exception)
    expectations
  end

  # when an exception to raise is StandardError and the inner code does not catch Exception
  class MyError < StandardError; end
  def test_3
    subject(MyError, StandardError)
    expectations
  end

  # when an exception to raise is StandardError and the inner code does catch Exception
  class MyError2 < StandardError; end
  def test_4
    subject(MyError2, Exception)
    expectations
  end

  # when an exception to raise is Exception and the inner code does not catch Exception
  class MyError3 < Exception; end
  def test_5
    subject(MyError3, StandardError)
    expectations
  end

  # when an exception to raise is Exception and the inner code does catch Exception
  class MyError4 < Exception; end
  def test_6
    subject(MyError4, Exception)
    expectations
  end

end
