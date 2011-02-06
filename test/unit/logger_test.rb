require "test_helper"
require "schedule/logger"
require "tempfile"
require "timecop"

class LoggerTest < Test::Unit::TestCase
  context "creating a new logger" do
    context "with the path of an existing file" do
      setup do
        @file = Tempfile.new("log")
        @path = @file.path
        
        @file.write "Line 1\nLine2"
        @file.close
        
        @logger = Schedule::Logger.new(@path, "")
      end
      
      should "not overwrite the file" do
        assert_equal "Line 1\nLine2", File.read(@path)
      end
      
      teardown do
        @file.unlink
      end
    end
    
    context "with the path of a non-existing file" do
      setup do
        file = Tempfile.new("log")
        @path = file.path
        file.close
        file.unlink
        
        @logger = Schedule::Logger.new(@path, "")
      end
      
      should "create the file" do
        assert File.exists?(@path)
      end
    end
    
    context "with stdout" do
      should "not explode" do
        assert_nothing_raised { Schedule::Logger.new(STDOUT, "") }
      end
    end
  end
  
  context "logging a message" do
    setup do
      file = Tempfile.new("log")
      @path = file.path
      file.close
      file.unlink
      
      @logger = Schedule::Logger.new(@path, "Awesome")
      @now = Time.now
    end
    
    context "single line" do
      setup do
        Timecop.freeze(@now) do
          @logger.log("Testing 123")
        end
      end

      should "write to file immediately" do
        assert_match "Testing 123", File.read(@path)
      end

      should "prefix message with time and label" do
        assert_match /^.*#{@now.strftime("%Y-%m-%d %H:%M:%S")}.*Awesome.*Testing 123.*$/, File.read(@path)
      end

      context "logging a subsequent message" do
        setup do
          @logger.log("Entry number 2")
        end

        should "be written to a seperate line" do
          lines = File.read(@path).split(/\n/)
          assert_match "Testing 123", lines[0]
          assert_match "Entry number 2", lines[1]
        end
      end
    end
    
    context "multiple lines" do
      setup do
        Timecop.freeze(@now) do
          @logger.log("Multiline 1  \n\n Multiline 2\rMultiline 3  ")
        end
      end

      should "write as multiple, prefixed lines, preserving per-line whitespace and blank lines" do
        expecting = []
        expecting << "#{@now.strftime("%Y-%m-%d %H:%M:%S")} [Awesome] Multiline 1  "
        expecting << "#{@now.strftime("%Y-%m-%d %H:%M:%S")} [Awesome] "
        expecting << "#{@now.strftime("%Y-%m-%d %H:%M:%S")} [Awesome]  Multiline 2"
        expecting << "#{@now.strftime("%Y-%m-%d %H:%M:%S")} [Awesome] Multiline 3  "
        expecting << ""
        expecting = expecting.join("\n")
        
        assert_match expecting, File.read(@path)
      end
    end
  end
end
