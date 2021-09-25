def subject(throws, catches)
  $inner_attempted = nil
  $inner_succeeded = nil
  $caught_in_inner = nil
  $inner_ensure = nil

  $raised_in_outer = nil
  $not_raised_in_outer = nil
  $outer_ensure = nil

  Timeout.timeout(0.1, throws){
    begin
      $inner_attempted = true
      sleep 10
    rescue catches
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
