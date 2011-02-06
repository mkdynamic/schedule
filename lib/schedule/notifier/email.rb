require "schedule/notifier/base"
require "net/smtp"

module Schedule
  module Notifier
    class Email < Base
      def notify(subject, message)
        mail = []
        mail << "From: #{@from} <#{@from}>"
        mail << "To: #{@to} <#{@to}>"
        mail << "Subject: #{subject}"
        mail << "\n#{message}"
        mail = mail.join("\n")

        Net::SMTP.start("localhost") do |smtp|
          smtp.send_message(mail, @from, @to)
        end
      end
    end
  end
end
