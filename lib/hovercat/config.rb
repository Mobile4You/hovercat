module Hovercat
  class Config
    attr_reader :configs

    def initialize
      reset
    end

    def merge!(hash)
      @configs.merge!(hash)
    end

    private
    def reset
      @configs = DEFAULT_CONFIG.clone
    end

    DEFAULT_CONFIG = {
        exchange: 'thundercats.events',
        host: 'localhost',
        port: '5672',
        vhost: '/',
        user: 'guest',
        password: 'guest',
        log_file: 'hovercat.log',
        retry_attempts: 3,
        retry_delay_in_s: 600,
        retry_number_of_messages: 500
    }
  end
end
