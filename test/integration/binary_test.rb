require "test_helper"
require "tempfile"

class BinaryTest < Test::Unit::TestCase
  context "command runner" do
    context "with a successful command" do
      setup do
        @file = Tempfile.new("log")
        @path = @file.path
        @file.close
        @file.unlink

        command_to_run_path = File.expand_path("../commands/success")
        command_to_run = "#{command_to_run_path} #{@path}"

        command_runner_path = File.expand_path("../../bin/cr")

        @command = %{#{command_runner_path} "#{command_to_run}"}
      end

      should "return status code 0" do
        silence_stream(STDOUT) do
          assert_equal true, system(@command)
        end
      end

      teardown do
        File.unlink(@path) rescue nil
      end
    end
  end
end