class CreateHovercatMessageRetries < ActiveRecord::Migration[4.2]
  def change
    create_table :hovercat_message_retries do |t|
      t.text :payload
      t.text :header
      t.string :routing_key
      t.string :exchange
      t.integer :retry_count, default: 0

      t.timestamps
    end
  end
end
