require "thread"
require "stringio"

module Schedule
  class Logger
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
      
      @formatter ||= Proc.new { |line, timestamp| "#{timestamp.strftime("%Y-%m-%d %H:%M:%S")} [#{@prefix}] #{line}" }
      @buffer = StringIO.new
      @prefix = prefix
      @semaphore = Mutex.new
    end

    def log(msg)
      timestamp = Time.now
      
      @semaphore.synchronize do
        begin
          @device.flock(File::LOCK_EX) if device_is_file?
          unless (lines = msg.split(/[\n\r]/)).empty?
            @device.write(format(lines, timestamp))
            @buffer.write(lines.join("\n") + "\n")
          end
        ensure
          @device.flock(File::LOCK_UN) if device_is_file? rescue nil
        end
      end
    end

    def close
      @device.close
    end

    private

    def format(lines, timestamp)
      lines.map { |line| @formatter.call(line, timestamp) }.join("\n") + "\n"
    end

    def device_is_file?
      @device_is_file ||= @device.is_a?(File)
    end
  end
end
