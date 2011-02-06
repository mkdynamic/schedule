require "schedule/notifier/base"

module Schedule
  module Notifier
    class Console < Base
      def notify(subject, message)
        mail = []
        mail << "From: #{@from} <#{@from}>"
        mail << "To: #{@to} <#{@to}>"
        mail << "Subject: #{subject}"
        mail << "\n#{message}"
        mail = mail.join("\n")

        puts mail
      end
    end
  end
end
