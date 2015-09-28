module DockerCompose
  module Generator
    class Service
      # Handles Pid Option in the docker-compose file
      module Pid
        def pid=(value)
          return @attrs['pid'] = 'host' if value.is_a?(TrueClass)
          @attrs.delete('pid')
        end
      end
    end
  end
end
