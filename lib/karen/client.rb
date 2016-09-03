module Karen
  class Client
    @commands = []

    class << self
      attr_accessor :commands

      def configure
        yield self
      end

      def run_every(seconds = 60, &command)
        commands << {seconds: seconds.to_i, block: command}
      end
    end

    def configure(&config)
      self.class.configure(&config)
    end

    def start
      min_timeout, max_timeout = *timeout_array

      iterations = 0
      loop do
        # Decide whether to run the command or not
        # Meaning, does command[:seconds] divide min_timeout * iterations

        commands.each do |command|
          command[:block].call if (min_timeout * iterations) % command[:seconds] == 0
        end

        # If we're at the max timeout, reset
        (min_timeout * iterations == max_timeout) ? iterations = 0 : iterations += 1

	      puts "sleeping for #{min_timeout}, iteration: #{iterations}"
        sleep min_timeout
      end
    end

    private

    def commands
      self.class.commands
    end

    def timeout_array
      seconds = commands.map{|command| command[:seconds]}
      [seconds.inject{|res, n| res.gcd(n)}, seconds.max]
    end
  end
end
