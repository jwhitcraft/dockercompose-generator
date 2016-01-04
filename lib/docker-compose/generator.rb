require 'yaml'
require 'docker-compose/generator/version'
require 'docker-compose/generator/service'

module DockerCompose
  # Static Generator Class
  # Used to create and keep track of services
  module Generator
    # Services Cache
    #
    # @param [Hash]
    @services = {}

    # Create a new service
    #
    # @param [String] name
    #   The name of the service in docker
    # @param [String] image
    #   The Image that the service will use in docker
    # @return [Service]
    def self.create_service(name, image)
      @services[name] = Service.new(name, image)
    end

    # Does this service exist?
    #
    # @param [String] name
    #   The name of the service to check for
    # @return [Boolean]
    def self.service?(name)
      (@services[name])
    end

    # Return a Service
    #
    # @param [String] name
    #   The name of the service to return
    #
    # @return [Service]
    def self.get_service(name)
      @services[name] if self.service?(name)
    end

    # Remove a Service
    #
    # @param [String] name
    #   The name of the service to remove
    #
    # @return [Service|Nil]
    #   The removed service, or nil if no service was removed
    def self.remove_service!(name)
      @services.delete(name)
    end

    # Convert The Services to Yaml
    def self.to_yaml
      yaml = {}

      @services.each do |key, obj|
        yaml[key] = obj.attrs
      end

      yaml.to_yaml
    end

    # Reset the List of Services
    def self.reset!
      @services = {}
    end

    # Import
    #
    # @param [Hash] yaml_object
    #   The yaml object to convert to services
    def self.import(yaml_object)
      yaml_object.each do |key, value|
        service = create_service(key, value['image'])
        service.import(value)
      end
    end
  end
end
