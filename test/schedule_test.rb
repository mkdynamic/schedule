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
    
    # scheduling them
    # scheduler = Schedule::Scheduler.new
    # job = Schedule::Job.new do |job|
    #   job.task = Schedule::Task.new("Test Task", "pwd")
    #   job.logger = Schedule::Logger.new(STDOUT, "Test Task")
    #   job.notifer = Schedule::Notifier::Console.new("system@mkdynamic.co.uk", "system@mkdynamic.co.uk")
    #   job.schedule = { :every => 1.minute }
    # end
    # scheduler.add(job)
    # 
    # scheduler.start # start the daemon
  end
end