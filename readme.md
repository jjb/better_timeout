# Sane Timeout

## Open Questions
* on line 69, I had tried doing x.join based on the standard lib doing the
same thing with the y thread. I assumed that kill is not synchromous so it's
necessary to wait for x to die. However, doing this causes many things to break.
I haven't been able to figure out why.
* related, is there any reason to kill y before returning x.value?

# Project Improvement
* There is redundant code between test_timeout.rb and test_sane_timeout.rb
because I wanted to annotate in the former and be DRY in the latter. Maybe this
can somehow be improved.

## odd design choice in standard lib:
* same type of error is raised inside thread and outside when specified
* when not specified, Exception is raised inside, StandardError is raised outside
