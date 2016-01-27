module DockerCompose
  module Generator
    class Service
      # Handles Labels in the docker-compose file
      module Labels
        def add_label(name, value)
          add_to_object('labels', name, value)
        end

        def get_label(name)
          get_from_object('labels', name) if label?(name)
        end

        def drop_label(name)
          drop_from_object('labels', name)
        end

        def label?(name)
          (@attrs['labels'] && @attrs['labels'][name])
        end
      end
    end
  end
end
