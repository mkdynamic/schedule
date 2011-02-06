require "thread"
require "stringio"

module Schedule
  class Logger
    LINE_SEPERATOR = /\r\n|\n|\r/ # CRLF, LF or CR
    
    attr_reader :buffer
    
    def initialize(device, prefix)
      if device == STDOUT
        @device = device
      elsif device.is_a?(String)
        @device = File.open(device, File::WRONLY | File::APPEND | File::CREAT)
        @device.sync = true
      else
        raise ArgumentError, "Log device must be a file path or STDOUT"
      end
      
      @formatter = Proc.new { |line, timestamp| "#{timestamp.strftime("%Y-%m-%d %H:%M:%S")} [#{@prefix}] #{line}" }
      @buffer = StringIO.new
      @prefix = prefix
      @semaphore = Mutex.new
    end

    def log(msg)
      timestamp = Time.now
      
      # split into lines, preserving whitespace
      lines = msg.split(LINE_SEPERATOR)
      msg.scan(LINE_SEPERATOR).size.times { lines << "\n" } if lines.empty?
      
      unless lines.empty?
        @semaphore.synchronize do
          @device.flock(File::LOCK_EX) if device_is_file?
          begin
            @device.write(lines.map { |line| @formatter.call(line, timestamp) }.join("\n") + "\n")#
            @buffer.write(lines.join("\n") + "\n")
          ensure
            @device.flock(File::LOCK_UN) if device_is_file?
          end
        end
      end
    end

    def close
      @device.close
    end

    private

    def device_is_file?
      @device_is_file ||= @device.is_a?(File)
    end
  end
end
