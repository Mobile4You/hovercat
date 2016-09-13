module Hovercat
  require 'bunny'
  class Publisher
    def publish(params)
      Hovercat::CONFIG[:host]

      result = true

      begin
        connection = Bunny.new(host: Hovercat::CONFIG[:host],
                               port: Hovercat::CONFIG[:port],
                               vhost: Hovercat::CONFIG[:vhost],
                               user: Hovercat::CONFIG[:user],
                               password: Hovercat::CONFIG[:password])
        connection.start
        channel = connection.create_channel
        exchange = channel.topic(params[:exchange] || Hovercat::CONFIG[:exchange], durable: true)

        result = exchange.publish(params[:payload], routing_key: params[:routing_key], headers: params[:header])
        connection.close
      rescue Bunny::Exception, Bunny::ClientTimeout, Bunny::ConnectionTimeout
        result = false
      end

      result
    end
  end
end