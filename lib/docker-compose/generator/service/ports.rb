module DockerCompose
  module Generator
    class Service
      # Handles Ports in the docker-compose file
      module Ports
        def add_port(host, container = nil)
          host = "#{host}:#{container}" if container

          add_to_array('ports', "#{host}")
        end

        def drop_port(host, container)
          host = "#{host}:#{container}" if container

          drop_from_array('ports', "#{host}")
        end

        def port?(host, container = nil)
          host = "#{host}:#{container}" if container

          ports = @attrs['ports'] || []
          ports.include?("#{host}")
        end
      end
    end
  end
end
