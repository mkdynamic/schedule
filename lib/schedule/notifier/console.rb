require "schedule/notifier/base"

module Schedule
  module Notifier
    class Console < Base
      private

      def notify!
        mail = []
        mail << "From: #{@options[:from]} <#{@options[:from]}>"
        mail << "To: #{@options[:to]} <#{@options[:to]}>"
        mail << "Subject: #{subject}"
        mail << "\n#{@message}"
        mail = mail.join("\n")

        puts mail
      end

      def subject
        "[Schedule] #{@task.name}"
      end
    end
  end
end
