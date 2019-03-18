[![Code Climate](https://codeclimate.com/github/Mobile4You/hovercat/badges/gpa.svg)](https://codeclimate.com/github/Mobile4You/hovercat)
[![codebeat badge](https://codebeat.co/badges/fc8d0613-78eb-45a4-83d8-197a167115cd)](https://codebeat.co/projects/github-com-mobile4you-hovercat)
[![Build Status](https://travis-ci.org/Mobile4You/hovercat.svg?branch=master)](https://travis-ci.org/Mobile4You/hovercat)

# Hovercat, a client for rabbitmq 
Your focuses on ease of use. It focus on 
to retry send message when message broker is down

## Supported RabbitMQ Versions

RabbitMQ `3.3+`.

## Installation & Bundler Dependency

```sh
$ gem gem install hovercat
```

If you prefer install in your `Gemfile`:

```rb
gem 'hovercat'
```

### Getting Started

First of all you have to select your retry mode
Hovercat has two retry modes:

Redis
Memory

You can generate de configuration file running the following commands:

hovercat redis_store
or
hovercat memory_store

It will genereate a configuration file like this:

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