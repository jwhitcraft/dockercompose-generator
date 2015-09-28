module DockerCompose
  module Generator
    class Service
      # Handles Environment Variables in the docker-compose file
      module Environment
        def add_environment(name, value)
          add_to_object('environment', name.upcase, value)
        end

        def drop_environment(name)
          drop_from_object('environment', name.upcase)
        end

        def environment?(name)
          (@attrs['environment'] && @attrs['environment'][name.upcase])
        end
      end
    end
  end
end
