module HoverCat
  class Config
    class << self
      attr_accessor :exchange

      attr_accessor :host
      attr_accessor :port
      attr_accessor :vhost

      attr_accessor :user
      attr_accessor :password
      attr_accessor :retry_attempts
      attr_accessor :log_file

      def reset
        @exchange = 'thundercats.events'
        @host = 'localhost'
        @port = '5672'
        @vhost = '/'
        @user = 'guest'
        @password = 'guest'
        @log_file = 'hovercat.log'
        @retry_attempts = '3'
      end
    end

    reset # Set default values for configuration options on load
  end
end
