require "thread"
require "stringio"

module Schedule
  # TODO buffer to tmp file, then write the whole thing to the main log on close
  # Unbuffered, thread and multiprocess safe
  class Logger
    attr_reader :buffer
    
    def initialize(device, prefix)
      @buffer = StringIO.new
      
      if device.respond_to?(:write)
        @device = device
      else
        @device = File.open(device, File::WRONLY | File::APPEND | File::CREAT)
        @device.sync = true
      end
      
      @prefix = prefix
      @semaphore = Mutex.new
    end

    def log(msg)
      timestamp = Time.now
      
      @semaphore.synchronize do
        begin
          @device.flock(File::LOCK_EX) if device_is_file?
          formatted_msg = format(msg, timestamp)
          @device.write(formatted_msg)
          @buffer.write(formatted_msg)
        ensure
          @device.flock(File::LOCK_UN) if device_is_file? rescue nil
        end
      end
    end

    def close
      @device.close
    end

    private

    def format(msg, timestamp)
      msg.split(/[\n\r]/).map { |line| 
        "#{timestamp.strftime("%Y-%m-%d %H:%M:%S")} [#{@prefix}] #{line.chomp}" 
      }.join("\n") + "\n"
    end

    def device_is_file?
      @device_is_file ||= @device.is_a?(File)
    end
  end
end
