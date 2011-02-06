require "schedule/notifier/base"
require "net/smtp"

module Schedule
  module Notifier
    class Email < Base
      private

      def notify!
        mail = []
        mail << "From: #{@options[:from]} <#{@options[:from]}>"
        mail << "To: #{@options[:to]} <#{@options[:to]}>"
        mail << "Subject: #{subject}"
        mail << "\n#{@message}"
        mail = mail.join("\n")

        Net::SMTP.start("localhost") do |smtp|
          smtp.send_message(mail, @options[:from], @options[:to])
        end
      end

      def subject
        "[Schedule] #{@task.name}"
      end
    end
  end
end
