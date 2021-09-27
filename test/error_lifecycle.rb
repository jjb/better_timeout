class MyStandardError < StandardError; end
class MyException< Exception; end

def subject(error_to_raise, error_to_rescue)
  $inner_attempted = nil
  $inner_else = nil
  $inner_rescue = nil
  $inner_ensure = nil

  $outer_rescue = nil
  $outer_else = nil
  $outer_ensure = nil

  begin
    Timeout.timeout(0.001, error_to_raise){
      begin
        $inner_attempted = true
        nil while true
      rescue error_to_rescue
        $inner_rescue = true
      else
        $inner_else = true
      ensure
        $inner_ensure = true
      end
    }
  rescue Exception
    $outer_rescue = true
  else
    $outer_else = true
  ensure
    $outer_ensure = true
  end

  unless !!$outer_else ^ !!$outer_rescue
    raise "something strange happened with the outer_rescue variables"
  end
end
