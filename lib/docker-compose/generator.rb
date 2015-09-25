require 'yaml'
require 'docker-compose/generator/version'
require 'docker-compose/generator/service'

module DockerCompose
  module Generator

    # Services Cache
    #
    # @param [Hash]
    @services = {}

    def self.create_service(name, image)
      @services[name] = Service.new(name, image)
    end

    def self.service?(name)
      (@services[name])
    end

    def self.get_service(name)
      @services[name] if self.service?(name)
    end

    def self.to_yaml
      yaml = {}

      @services.each do |key,obj|
        yaml[key] = obj.attrs
      end

      yaml.to_yaml
    end
  end
end
