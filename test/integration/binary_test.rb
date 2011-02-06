require "test_helper"
require "tempfile"

class BinaryTest < Test::Unit::TestCase
  context "command runner" do
    context "successful command" do
      setup do
        @file = Tempfile.new("log")
        @path = @file.path
        @file.close
        @file.unlink

        command_to_run_path = File.expand_path("../commands/success")
        @command_to_run = "#{command_to_run_path} #{@path}"
        @command_runner_path = File.expand_path("../../bin/cr")
      end
      
      context "no options" do
        setup do
          @command = %{#{@command_runner_path} "#{@command_to_run}"}
        end
        
        should "execute command" do
          silence_stream(STDOUT) do
            system(@command)
            assert File.exists?(@path)
          end
        end

        should "return status code 0" do
          silence_stream(STDOUT) do
            assert_equal true, system(@command)
          end
        end
        
        should "log to stdout"
      end
      
      teardown do
        File.unlink(@path) rescue nil
      end
    end
  end
end