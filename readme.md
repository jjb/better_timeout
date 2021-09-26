# SaneTimeout

This is a fork of ruby 1.9.3 timeout which has the following behavior change:

Regardless of what errors the timed code catches, `Timeout.timeout` will
always raise an exception if the code times out.

When the gem is installed, sane_timeout takes over Timeout.timeout in all cases.

## Installation

Add this line to your application's Gemfile:

    gem 'sane_timeout'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sane_timeout


## Discussion/findings

### In standlib
* same type of error is raised inside thread and outside when specified
* when not specified, Exception is raised inside, StandardError is raised outside
