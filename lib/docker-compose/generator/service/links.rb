module DockerCompose
  module Generator
    class Service
      # Handles Service Links in the docker-compose file
      module Links
        def add_link(service, link_name = nil)
          add_to_array('links', link_name(service.name, link_name))
        end

        def drop_link(service, link_name = nil)
          drop_from_array('links', link_name(service.name, link_name))
        end

        def link?(service, link_name = nil)
          links = @attrs['links'] || []
          links.include?(link_name(service.name, link_name))
        end

        def add_external_link(service_name, link_name = nil)
          add_to_array('external_links', link_name(service_name, link_name))
        end

        def drop_external_link(service_name, link_name = nil)
          drop_from_array('external_links', link_name(service_name, link_name))
        end

        def external_link?(service_name, link_name = nil)
          links = @attrs['external_links'] || []
          links.include?(link_name(service_name, link_name))
        end

        private

        def link_name(name, link_name = nil)
          (link_name) ? "#{name}:#{link_name}" : "#{name}"
        end
      end
    end
  end
end
