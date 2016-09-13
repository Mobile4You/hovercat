module Hovercat
  class MessageGateway
    def send(params)
      header = params[:header] || {}
      exchange = params[:exchange] || 'amq.topic'
      publisher = params[:publisher] || Hovercat::Publisher.new
      message = params[:message]

      message_attributes = {payload: message.to_json, header: header, routing_key: message.routing_key, exchange: exchange}
      begin
        unless publisher.publish(message_attributes)
          Hovercat::MessageRetry.create!(message_attributes)
        end
      rescue StandardError => e
        raise Hovercat::UnableToSendMessageError.new(e)
      end
    end
  end
end
