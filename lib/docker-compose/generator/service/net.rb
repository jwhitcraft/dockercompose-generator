module DockerCompose
  module Generator
    class Service
      # Handles Net Option in the docker-compose file
      module Net
        def net=(value)
          return @attrs.delete('net') if value.nil?
          valid_values = %w(bridge none host container:name container:id)
          @attrs['net'] = value if valid_values.include?(value)
        end
      end
    end
  end
end
