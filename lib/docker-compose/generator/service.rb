module DockerCompose
  module Generator
    class Service
      attr_reader :name, :attrs

      def initialize(name, image)
        @name = name
        @attrs = {
          'image' => image
        }
      end

      def add_environment(name, value)
        add_to_object('environment', name.upcase, value)
      end

      def drop_environment(name)
        drop_from_object('environment', name.upcase)
      end

      def environment?(name)
        (@attrs['environment'] && @attrs['environment'][name.upcase])
      end

      def add_link(service, link_name = nil)
        name = service.name
        name = "#{name}:#{link_name}" unless link_name.nil?

        add_to_array('links', name)
      end

      def drop_link(service, link_name = nil)
        name = service.name
        name = "#{name}:#{link_name}" unless link_name.nil?

        drop_from_array('links', name)
      end

      def link?(service, link_name = nil)
        name = service.name
        name = "#{name}:#{link_name}" unless link_name.nil?

        links = @attrs['links'] || []
        links.include?(name)
      end

      def add_port(source, target = nil, type = 'tcp')
        target ||= source

        add_to_array('ports', "#{source}:#{target}/#{type}")
      end

      def drop_port(source, target, type='tcp')
        target ||= source

        drop_from_array('ports', "#{source}:#{target}/#{type}")
      end

      def port?(source, target = nil, type='tcp')
        target ||= source

        ports = @attrs['ports'] || []
        ports.include?("#{source}:#{target}/#{type}")
      end

      private

      def add_to_array(array_name, value)
        @attrs[array_name] ||= []
        @attrs[array_name].push(value)
      end

      def drop_from_array(array_name, value)
        @attrs[array_name] ||= []
        @attrs[array_name].delete(value)
      end

      def add_to_object(obj_key, key, value)
        @attrs[obj_key] ||= {}
        @attrs[obj_key][key] = value
      end

      def drop_from_object(obj_key, key)
        @attrs[obj_key] ||= {}
        @attrs[obj_key].delete(key)
      end
    end
  end
end
