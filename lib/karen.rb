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
      load_config
      load_initializers
      initialize_services
    end

    def configure(&config)
      Karen::Configuration.new(&config)
    end

    private

    def load_from_directory(relative_directory)
      Dir[File.dirname(__FILE__) + relative_directory].each { |file| require file }
    end

    def load_config
      load_from_directory '/karen/config/*.rb'
    end

    def load_initializers
      load_from_directory '/karen/initializers/*.rb'
    end

    def initialize_services
      services.each { |service| service.load! }
    end
  end
end