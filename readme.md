# SaneTimeout

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'sane_timeout'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sane_timeout

## Usage

TODO: Write usage instructions here



## Open Questions
* on line 69, I had tried doing x.join based on the standard lib doing the
same thing with the y thread. I assumed that kill is not synchromous so it's
necessary to wait for x to die. However, doing this causes many things to break.
I haven't been able to figure out why.
* related, is there any reason to kill y before returning x.value?

## To Do
* determine best way to install sane_timeout so that it
  replaces Timeout. possibly offer to modes, one where
  Timeout is overwritten, another where sane_timeout is
  invoked in its own namespace (SaneTimeout)

## Project Improvement
* better name?
* There is redundant code between test_timeout.rb and test_sane_timeout.rb
because I wanted to annotate in the former and be DRY in the latter. Maybe this
can somehow be improved.

## odd design choice in standard lib:
* same type of error is raised inside thread and outside when specified
* when not specified, Exception is raised inside, StandardError is raised outside
