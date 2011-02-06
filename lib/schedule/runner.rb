require "schedule/logger"

module Schedule
  class Runner
    def initialize(task, logger = nil, notifier = nil)
      @task = task
      @logger = logger || Logger.new(STDOUT, @task.name)
      @notifier = notifier
    end
    
    def run
      @logger.log "=== Started (#{@task.command}) ==="
    
      status = nil
      
      duration = with_timing do
        status = execute(@task.command) do |output|
          buffer = ""
          begin
            while (buffer << output.readpartial(1024))
              if lines = buffer.slice!(/^.*[\n\r]/m)
                @logger.log(lines)
              end
            end
          rescue EOFError
            @logger.log(buffer) unless buffer == ""
          ensure
            buffer = nil
          end
        end
      end
    
      exit_status = if status && status.exitstatus == 0
        0
      elsif status && status.exitstatus
        status.exitstatus
      else
        1
      end
    
      if exit_status == 0
        @logger.log "=== Completed successfully (took #{duration} seconds) ==="
      else
        @logger.log "=== Failed (took #{duration} seconds) ==="
      end
      
      if @notifier
        @notifier.notify(@task, @logger.buffer.string)
      end
      
      return exit_status
    end

    private

    # executes system command as a child process (fork + exec)
    # returns stdout and stderr as a single stream
    # will execute code inside block
    def execute(cmd)
      status = nil
      
      begin
        pipe = IO::pipe
        
        pid = fork do
          pipe[0].close
          STDOUT.reopen(pipe[1])
          pipe[1].close

          STDERR.reopen(STDOUT)

          begin
            exec cmd
          rescue => e 
            # only some ruby level errors (e.g. exec('nonexistentfile')), caught here by this rescue
            # once the process is exec'd it'll take us over so any errors at that
            # level will be piped to STDERR/STDOUT and dealt with in out execute block in #run
            STDERR.puts "Error running command: #{e.to_s} (#{e.class.name})"#\n#{e.backtrace.map { |l| "    from #{l}" }.join("\n")}"
            exit(1)
          end
        end

        pipe[1].close
        
        yield pipe[0]
      ensure
        _, status = Process.waitpid2(pid)# rescue nil
        pipe.each { |io| io.close unless io.closed? }# rescue nil
      end
      
      status
    end
  
    def with_timing
      started = Time.now
      yield
      finished = Time.now
      finished - started
    end
  end
end
