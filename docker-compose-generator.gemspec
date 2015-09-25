# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docker-compose/generator/version'

Gem::Specification.new do |spec|
  spec.name         = 'dockercompose-generator'
  spec.version      = DockerCompose::Generator::VERSION
  spec.authors      = ['Jon Whitcraft']
  spec.email        = ['jwhitcraft@h2ik.co']
  spec.summary      = 'Programmatically create a yaml file for docker-compose'
  spec.description  = ''
  spec.homepage     = 'https://github.com/jwhitcraft/dockercompose-generator'
  spec.license      = 'MIT'

  spec.files        = `git ls-files -z`.split("\x0")
  spec.executables  = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files   = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
