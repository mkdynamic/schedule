require "test_helper"
require "schedule"

class ScheduleTest < Test::Unit::TestCase
  should "work" do
    # creating tasks and running them
    task = Schedule::Task.new("Test Task", "cd /users/markdodwell; du -hs .")
    logger = Schedule::Logger.new(STDOUT, task.name)
    notifier = Schedule::Notifier::Console.new("system@mkdynamic.co.uk", "system@mkdynamic.co.uk")
    runner = Schedule::Runner.new(task, nil, notifier)
    
    runner.run
  end
end