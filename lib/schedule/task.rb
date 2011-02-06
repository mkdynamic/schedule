module Schedule
  class Task
    attr_reader :name, :command
    
    def initialize(name, command)
      @name = name
      @command = command
    end
  end
end
