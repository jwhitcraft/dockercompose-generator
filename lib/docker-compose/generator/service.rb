require 'docker-compose/generator/service/ports'
require 'docker-compose/generator/service/links'
require 'docker-compose/generator/service/environment'
require 'docker-compose/generator/service/labels'
require 'docker-compose/generator/service/net'
require 'docker-compose/generator/service/pid'
require 'docker-compose/generator/service/volumes'

module DockerCompose
  module Generator
    # Service Class
    #
    # Used to interact with services
    class Service
      # Handles Ports
      include Ports
      # Handles Links and External Links
      include Links
      # Handles Environment Variables
      include Environment
      # Handles Labels
      include Labels
      # Handles Net Setting
      include Net
      # Handles Pid Setting
      include Pid
      # Handles Volumes
      include Volumes

      attr_reader :name, :attrs

      # Initialize Method
      #
      # @param [String] name
      #   The name of the service
      #
      # @param [String] image
      #   The image to use
      def initialize(name, image)
        @name = name
        @attrs = {
          'image' => image
        }
      end

      # Variables that only allow one value
      #
      # Create the {method=} and {method?} methods dynamically
      # since these only accept one value
      [:build, :dockerfile, :command, :working_dir, :entrypoint, :user,
       :hostname, :domainname, :mac_address, :mem_limit, :memswap_limit,
       :privileged, :restart, :stdin_open, :tty, :cpu_shares, :cpuset,
       :read_only, :volume_driver, :container_name, :image].each do |method|
        define_method "#{method}?" do
          (@attrs["#{method}"])
        end
        define_method "#{method}=" do |value|
          @attrs["#{method}"] = value
        end
      end

      # Variables that are a list of single items
      #
      # Create the {add_method}, {drop_method} and {method?} dynamically
      # since they accept a list of single objects
      [:expose, :volumes_from, :dns, :extra_hosts, :dns_search, :cap_add,
       :cap_drop, :env_file].each do |method|
        define_method "#{method}?" do |item|
          items = @attrs["#{method}"] || []
          items.include?(item)
        end

        define_method "add_#{method}" do |item|
          add_to_array("#{method}", item)
        end

        define_method "drop_#{method}" do |item|
          drop_from_array("#{method}", item)
        end
      end

      # Import the attrs hash
      #
      # @param [Hash] attrs
      #   The attribute hash from the main import
      def import(attrs)
        @attrs = attrs
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

      def get_from_object(obj_key, key)
        @attrs[obj_key][key]
      end

      def drop_from_object(obj_key, key)
        @attrs[obj_key] ||= {}
        @attrs[obj_key].delete(key)
      end
    end
  end
end
