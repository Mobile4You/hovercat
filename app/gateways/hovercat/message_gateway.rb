module Hovercat
  class MessageGateway
    def send(params) # def send(header = {}, exchange = 'amq.topic', publisher = Hovercat::Publisher.new, message)
      header = params[:header] || {}
      exchange = params[:exchange] || Hovercat::CONFIG[:exchange]
      publisher = params[:publisher] || Hovercat::Publisher.new
      message = params[:message]

      message_attributes = {payload: message.to_json, header: header, routing_key: message.routing_key, exchange: exchange}
      begin
        unless publisher.publish(message_attributes)
          Hovercat::MessageRetry.create!(message_attributes)
        end
      rescue StandardError
        raise Hovercat::UnableToSendMessageError.new
      end
    end
  end
end
