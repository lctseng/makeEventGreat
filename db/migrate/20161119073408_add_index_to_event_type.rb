class AddIndexToEventType < ActiveRecord::Migration[5.0]
  def change
    add_index :event_types, :name
  end
end
