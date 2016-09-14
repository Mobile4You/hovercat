class ChangeRetryCountForNotNullToMessageRetries < ActiveRecord::Migration[5.0]
  def change
    change_column_null :hovercat_message_retries, :retry_count, false
  end
end
