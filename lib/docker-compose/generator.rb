require 'yaml'
require 'docker-compose/generator/version'
require 'docker-compose/generator/service'

module DockerCompose
  module Generator

    @@services

    def self.create_service(name, image)
      @@services ||= {}
      @@services[name] = Service.new(name, image)
    end

    def self.has_service?(name)
      !!(@@services[name])
    end

    def self.get_service(name)
      @@services[name] if self.has_service?(name)
    end

    def self.to_yaml

      yaml = {}

      @@services.each {|key,obj|
        yaml[key] = obj.attrs
      }

      yaml.to_yaml
    end
  end
end
