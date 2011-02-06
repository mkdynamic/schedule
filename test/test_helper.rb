require "rubygems"
require "test/unit"
require "shoulda"

class Test::Unit::TestCase
  # from ActiveSupport 3
  def silence_stream(stream)
    old_stream = stream.dup
    stream.reopen(RbConfig::CONFIG["host_os"] =~ /mswin|mingw/ ? "NUL:" : "/dev/null")
    stream.sync = true
    yield
  ensure
    stream.reopen(old_stream)
  end
end
