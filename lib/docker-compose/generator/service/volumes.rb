module DockerCompose
  module Generator
    class Service
      # Handles Volumes in the docker-compose file
      module Volumes
        def add_volume(host, container = nil, mode = nil)
          add_to_array('volumes', volume_name(host, container, mode))
        end

        def drop_volume(host, container, mode = nil)
          drop_from_array('volumes', volume_name(host, container, mode))
        end

        def volume?(host, container = nil, mode = nil)
          volumes = @attrs['volumes'] || []
          volumes.include?(volume_name(host, container, mode))
        end

        private

        def volume_name(host, container = nil, mode = nil)
          volume = "#{host}:#{container}" if container
          volume += ":#{mode}" if container && mode

          volume
        end
      end
    end
  end
end
