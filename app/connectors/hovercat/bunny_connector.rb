module Hovercat
  class BunnyConnector
    def initialize(gem = Bunny)
      @connection = gem.new(host: Hovercat::CONFIG[:host],
                              port: Hovercat::CONFIG[:port],
                              vhost: Hovercat::CONFIG[:vhost],
                              user: Hovercat::CONFIG[:user],
                              password: Hovercat::CONFIG[:password])
    end

    def publish(params)
      begin
        @connection.start
        channel = @connection.create_channel
        exchange = channel.topic(params[:exchange] || Hovercat::CONFIG[:exchange], durable: true)

        exchange.publish(params[:payload], routing_key: params[:routing_key], headers: params[:header])
      rescue StandardError, Timeout::Error => e
        raise Hovercat::UnexpectedError.new
      ensure
        if @connection.open?
          @connection.close
        end
      end
    end
  end
end
