module DockerCompose
  # Injects the VERSION into the Generator Module
  module Generator
    # Current major release.
    # @return [Integer]
    MAJOR = 0

    # Current minor release.
    # @return [Integer]
    MINOR = 4

    # Current patch level.
    # @return [Integer]
    PATCH = 2

    # Full release version.
    # @return [String]
    VERSION = [MAJOR, MINOR, PATCH].join('.').freeze
  end
end
