[![Code Climate](https://codeclimate.com/github/Mobile4You/hovercat/badges/gpa.svg)](https://codeclimate.com/github/Mobile4You/hovercat)
[![codebeat badge](https://codebeat.co/badges/fc8d0613-78eb-45a4-83d8-197a167115cd)](https://codebeat.co/projects/github-com-mobile4you-hovercat)
[![Build Status](https://travis-ci.org/Mobile4You/hovercat.svg?branch=master)](https://travis-ci.org/Mobile4You/hovercat)

# Hovercat is a client for Rabbitmq 
Your focuses on ease of use. It focus on 
to retry send message when message broker is down

## Supported RabbitMQ Versions

RabbitMQ `3.3+`.

## Installation & Bundler Dependency

Install in your `Gemfile`:

```rb
gem 'hovercat', git: 'https://github.com/Mobile4You/hovercat.git'
```

### Getting Started

First of all you have to genereate a configuration file

You can generate de configuration file running the following command:

```sh
$ hovercat memory_store
```

It will generate a configuration file like this:

```rb
hovercat:
  rabbitmq:
    host: 'localhost'
    port: 5672
    exchange: ''
    vhost: '/'
    user: 'guest'
    password: 'guest'
  retries_in_rabbit_mq:
    retry_attempts: 3
    retry_delay_in_seconds: 600
```

### If you have old version of hovervat and would like to upgrade

1 - Execute
```sh
bundle update hovercat
```
2 - Change your message model
from:
```ruby
Hovercat::Message
Hovercat::MessageGateway
Hovercat::UnableToSendMessageError
```
to:
```ruby
Hovercat::Models::Message
Hovercat::Gateways::MessageGateway
Hovercat::Errors::UnableToSendMessageError
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request