require 'test/unit'
require_relative '../lib/better_timeout.rb'
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


  ### Tests that better_timeout passes

  require_relative 'error_lifecycle.rb'

  def expectations
    assert $inner_attempted,  "Inner was not attempted"
    assert !$inner_else, "Inner did not succeed"
    assert $inner_ensure, "Inner ensure was not reached"
    assert $outer_rescue,  "Exception was not raised in outer"
    assert $outer_ensure, "Outer ensure succeeded"
    assert !$outer_else, "Exception was not raised in outer(2)"
  end

  # when an exception to raise is not specified and the inner code does not catch Exception
  def test_1
    subject(nil, StandardError)
    expectations
    assert !$inner_rescue, "Exception was caught in inner"
  end

  # when an exception to raise is not specified and the inner code does catch Exception
  def test_2
    subject(nil, Exception)
    expectations
    assert $inner_rescue, "Exception was not caught in inner"
  end

  # when an exception to raise is StandardError and the inner code does not catch Exception
  def test_3
    subject(MyStandardError, StandardError)
    expectations
    assert $inner_rescue, "Exception was not caught in inner"
  end

  # when an exception to raise is StandardError and the inner code does catch Exception
  def test_4
    subject(MyStandardError, Exception)
    expectations
    assert $inner_rescue, "Exception was not caught in inner"
  end

  # when an exception to raise is Exception and the inner code does not catch Exception
  def test_5
    subject(MyException, StandardError)
    expectations
    assert !$inner_rescue, "Exception was caught in inner"
  end

  # when an exception to raise is Exception and the inner code does catch Exception
  def test_6
    subject(MyException, Exception)
    expectations
    assert $inner_rescue, "Exception was not caught in inner"
  end

end
