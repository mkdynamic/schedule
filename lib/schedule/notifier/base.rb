module Schedule
  module Notifier
    class Base
      def initialize(from, to)
        @from = from
        @to = to
      end

      def notify(subject, message)
        raise NotImplementedError, "You must subclass this method!"
      end
    end
  end
end
