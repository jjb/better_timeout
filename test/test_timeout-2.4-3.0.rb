require 'test/unit'
require 'timeout'
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


  ### Tests demonstrating problems with standard lib
  # NOTE: this demonstration was done such that all of the assertions pass,
  #       The ones marked weird, bad, and very bad should not, and their
  #       passing is demonstrating the brokenness.
  # ruby gem at 0f12a0ec11d4a860a56e74a2bb051a77fe70b006 also passes

  require_relative 'error_lifecycle.rb'

  # when an exception to raise is not specified and the inner code does not catch Exception
  def test_1
    subject(nil, StandardError)

    # EXPECTED
    assert $inner_attempted
    assert !$inner_else
    assert !$inner_rescue
    assert $inner_ensure
    assert $outer_rescue
    assert $outer_ensure
  end

  # when an exception to raise is not specified and the inner code does catch Exception
  def test_2
    subject(nil, Exception)

    # EXPECTED
    assert $inner_attempted
    assert !$inner_else
    assert $inner_ensure
    assert $outer_ensure
    assert $outer_rescue # was broken in 1.9

    # WEIRD
    assert !$inner_rescue # was working in 1.9
  end

  # when an exception to raise is StandardError and the inner code does not catch Exception
  def test_3
    subject(MyStandardError, StandardError)

    # EXPECTED
    assert $inner_attempted
    assert !$inner_else
    assert $inner_rescue
    assert $inner_ensure
    assert $outer_ensure

    # BAD
    assert !$outer_rescue
  end

  # when an exception to raise is StandardError and the inner code does catch Exception
  def test_4
    subject(MyStandardError, Exception)

    # EXPECTED
    assert $inner_attempted
    assert !$inner_else
    assert $inner_rescue
    assert $inner_ensure
    assert $outer_ensure

    # BAD
    assert !$outer_rescue
  end

  # when an exception to raise is Exception and the inner code does not catch Exception
  def test_5
    subject(MyException, StandardError)

    # EXPECTED
    assert $inner_attempted
    assert !$inner_else
    assert !$inner_rescue
    assert $inner_ensure
    assert $outer_ensure
    assert $outer_rescue
  end

  # when an exception to raise is Exception and the inner code does catch Exception
  def test_6
    subject(MyException, Exception)

    # EXPECTED
    assert $inner_attempted
    assert !$inner_else
    assert $inner_rescue
    assert $inner_ensure
    assert $outer_ensure

    # BAD
    assert !$outer_rescue
  end

end
