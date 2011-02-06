require "test_helper"
require "schedule/task"

class TaskTest < Test::Unit::TestCase
  context "a new task" do
    setup do
      @task = Schedule::Task.new("Testing", "pwd")
    end
    
    should "return #name of Testing" do
      assert_equal "Testing", @task.name
    end
    
    should "return #command of pwd" do
      assert_equal "pwd", @task.command
    end
  end
end
