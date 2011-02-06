require "test_helper"
require "schedule/task"
require "schedule/runner"
require "tempfile"

class RunnerTest < Test::Unit::TestCase
  context "a successful task" do
    setup do
      @file = Tempfile.new("log")
      @path = @file.path
      @file.close
      
      @task = Schedule::Task.new("Test", "echo `pwd` > #{@path}")
      @runner = Schedule::Runner.new(@task)
    end
    
    should "return 0" do
      silence_stream(STDOUT) do
        assert_equal 0, @runner.run
      end
    end
    
    should "execute command" do
      silence_stream(STDOUT) do
        @runner.run
        assert_equal `pwd`, File.read(@path)
      end
    end
    
    teardown do
      @file.unlink
    end
  end
  
  context "a non-existent command" do
    setup do
      @task = Schedule::Task.new("Test", "fsjfslsfdanl")
      @runner = Schedule::Runner.new(@task)
    end
    
    should "return 1" do
      silence_stream(STDOUT) do
        assert_equal 1, @runner.run
      end
    end
  end
  
  context "a command that raises an exception" do
    setup do
      @file = Tempfile.new("log")
      @path = @file.path
      @file.close
      @file.unlink
      
      @task = Schedule::Task.new("Test", File.expand_path("../../commands/raises_exception #{@path}", __FILE__))
      @runner = Schedule::Runner.new(@task)
    end
    
    should "execute command" do#
      silence_stream(STDOUT) do
        @runner.run
        assert File.exists?(@path)
      end
    end
    
    should "return 1" do
      silence_stream(STDOUT) do
        assert_equal 1, @runner.run
      end
    end
    
    teardown do
      File.unlink(@path) rescue nil
    end
  end
end
