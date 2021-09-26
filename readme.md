# Better Timeout

This is a fork of ruby 1.9.3 timeout which has the following behavior change:

Regardless of what errors the timed code catches, `Timeout.timeout` will
always raise an exception if the code times out.

The stack traces might also be nicer, but this is still be full tested.

When the gem is installed, better_timeout takes over Timeout.timeout in all cases.

## Installation

Add this line to your application's Gemfile:

    gem 'better_timeout', git: 'https://github.com/jjb/better_timeout'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install better_timeout


## Discussion/findings

### In standlib
* same type of error is raised inside thread and outside when specified
* when not specified, Exception is raised inside, StandardError is raised outside

----

_this project was formerly named sane_timeout_
