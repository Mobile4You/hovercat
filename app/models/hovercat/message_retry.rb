module Hovercat
  class MessageRetry < ApplicationRecord
    def too_many_retries?(attempts_limit)
      attempts_limit = attempts_limit || 0
      self.retry_count >= attempts_limit
    end
  end
end
