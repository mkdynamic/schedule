module Schedule
  module Notifier
    class Base
      def initialize(opts = {})
        @options = opts
      end

      def notify(task, message)
        @task = task
        @message = message
        notify!
      end
      
      protected
      
      def notify!
        raise NotImplementedError, "You must subclass this method!"
      end
    end
  end
end
