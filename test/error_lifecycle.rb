class MyStandardError < StandardError; end
class MyException< Exception; end

def subject(error_to_raise, error_to_rescue)
  $inner_attempted = nil
  $inner_succeeded = nil
  $caught_in_inner = nil
  $inner_ensure = nil

  $raised_in_outer = nil
  $not_raised_in_outer = nil
  $outer_ensure = nil

  Timeout.timeout(0.001, error_to_raise){
    begin
      $inner_attempted = true
      nil while true
    rescue error_to_rescue
      $caught_in_inner = true
    else
      $inner_succeeded = true
    ensure
      $inner_ensure = true
    end
  }
rescue Exception
  $raised_in_outer = true
else
  $not_raised_in_outer = true
ensure
  $outer_ensure = true
end
