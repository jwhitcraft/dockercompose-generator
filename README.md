# DockerCompose::Generator

[![Build Status](https://travis-ci.org/jwhitcraft/dockercompose-generator.svg?branch=master)](https://travis-ci.org/jwhitcraft/dockercompose-generator) [![Coverage Status](https://coveralls.io/repos/jwhitcraft/dockercompose-generator/badge.svg?branch=master&service=github)](https://coveralls.io/github/jwhitcraft/dockercompose-generator?branch=master) [![Code Climate](https://codeclimate.com/github/jwhitcraft/dockercompose-generator/badges/gpa.svg)](https://codeclimate.com/github/jwhitcraft/dockercompose-generator) [![Gem Version](https://badge.fury.io/rb/dockercompose-generator.svg)](http://badge.fury.io/rb/dockercompose-generator)

Generate a Docker-Compose Yaml file 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'docker-compose-generator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install docker-compose-generator

## Usage

```ruby
generator = DockerCompose::Generator
mysql = generator.create_service('db', 'mysql:5.6')
mysql.add_environment('mysql_root_password', 'root')
mysql.add_environment('mysql_database', 'test')
mysql.add_environment('mysql_user', 'test')
mysql.add_environment('mysql_password', 'test')
elastic = generator.create_service('elastic', 'elasticsearch:1.4')
web = generator.create_service('web', 'php:5.6-apache')
web.add_link(elastic)
web.add_link(mysql, 'mysql')
puts generator.to_yaml
```

will output

```yaml
db:
  image: mysql:5.6
  environment:
    MYSQL_ROOT_PASSWORD: root
    MYSQL_DATABASE: test
    MYSQL_USER: test
    MYSQL_PASSWORD: test
elastic:
  image: elasticsearch:1.4
web:
  image: php:5.6-apache
  links:
  - elastic
  - db:mysql
```

## Contributing

1. Fork it ( https://github.com/jwhitcraft/docker-compose-generator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
