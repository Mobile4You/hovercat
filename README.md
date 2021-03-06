[![Code Climate](https://codeclimate.com/github/Mobile4You/hovercat/badges/gpa.svg)](https://codeclimate.com/github/Mobile4You/hovercat)
[![codebeat badge](https://codebeat.co/badges/fc8d0613-78eb-45a4-83d8-197a167115cd)](https://codebeat.co/projects/github-com-mobile4you-hovercat)
[![Build Status](https://travis-ci.org/Mobile4You/hovercat.svg?branch=master)](https://travis-ci.org/Mobile4You/hovercat)

<p align="center">
  <img src="https://vignette.wikia.nocookie.net/thundercats/images/f/f2/Vlcsnap-2014-03-22-17h39m23s39.jpg/revision/latest?cb=20140322214308" alt="Hovercat"/>
</p>

# Hovercat is a client for Rabbitmq 
It will retry sending messages when the message broker is down.

## Supported RabbitMQ Versions

RabbitMQ `3.3+`.

## Installation & Bundler Dependency

Install in your `Gemfile`:

```rb
gem 'hovercat', git: 'https://github.com/Mobile4You/hovercat.git'
```

### Getting Started

1 - First of all you have to generate a configuration file, with this command:

```sh
$ hovercat memory_store
```

You could also use redis store:

```sh
$ hovercat redis_store
```

The configuration file will be generated inside the `./config` dir.

You can also send the rabbitmq configurations via params to `Hovercat::Sender.publish`

2 - Creating hovercat message is very simple, you only have to extend `Hovercat::Models::Message`:

Example:
```rb
  class Message < Hovercat::Models::Message
    def initialize(name:, email:)
      super('my.routing.key.name')
    
      add resource: name, as: :name
      add resource: email, as: :email
    end
  end
```

3 - To send a message, you have to use `Hovercat::Sender.publish`:

Example:
```rb
  message = Message.new(name: 'My name', email: 'myemail@example.com')
  params = { message: message, exchange: 'my-exchange', header: { 'header-example': 'my-header'} }
  Hovercat::Sender.publish(params)
```
If you use exchange via param, it has precedence over exchange name in configuration file.

### If you have an old version of hovercat and would like to upgrade:

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

3 - You may also need to re-generate the configuration file, since the configuration is now defined per environment (development, test, production, etc).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request