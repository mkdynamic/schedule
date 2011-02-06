require "schedule/notifier/base"
require "net/smtp"
require "tempfile"

module Schedule
  module Notifier
    class Email < Base
      private

      def notify!
        mail = []
        mail << "From: #{@options[:from]} <#{@options[:from]}>" if @options[:from]
        mail << "To: #{@options[:to]} <#{@options[:to]}>"
        mail << "Subject: #{subject}"
        mail << "\n#{@message}"
        mail = mail.join("\n")

        begin
          Net::SMTP.start("localhost") do |smtp|
            smtp.send_message(mail, @options[:from], @options[:to])
          end
        rescue
          mail_file = Tempfile.new("mail")
          mail_file.write(mail)
          mail_file.close
          begin
            result = system("sendmail #{@options[:to]} < #{File.expand_path(mail_file.path)}")
            raise unless result
          rescue => e
            raise "Could not deliver email using either local SMTP or sendmail!"
          ensure
            mail_file.unlink rescue nil
          end
        end
      end

      def subject
        "[Schedule] #{@task.name}"
      end
    end
  end
end
