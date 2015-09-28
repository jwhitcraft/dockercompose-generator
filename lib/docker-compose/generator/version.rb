module DockerCompose
  # Injects the VERSION into the Generator Module
  module Generator
    # Current major release.
    # @return [Integer]
    MAJOR = 0

    # Current minor release.
    # @return [Integer]
    MINOR = 2

    # Current patch level.
    # @return [Integer]
    PATCH = 0

    # Full release version.
    # @return [String]
    VERSION = [MAJOR, MINOR, PATCH].join('.').freeze
  end
end
