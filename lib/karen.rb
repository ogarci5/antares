module Karen
  class << self
    @client = nil
    attr_accessor :client

    Karen::Configuration::OPTIONS.each do |name|
      define_method(name) do
        Karen::Configuration.send(name)
      end
    end

    def initialize!
      Dir[File.dirname(__FILE__) + '/karen/config/*.rb'].each { |file| require file }
      Dir[File.dirname(__FILE__) + '/karen/initializers/*.rb'].each { |file| require file }
      Karen::Slack.load!
    end

    def configure(&config)
      Karen::Configuration.new(&config)
    end
  end
end