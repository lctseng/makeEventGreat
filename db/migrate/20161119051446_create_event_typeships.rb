class CreateEventTypeships < ActiveRecord::Migration[5.0]
  def change
    create_table :event_typeships, id: false do |t|
      t.belongs_to :event, index: true
      t.belongs_to :event_type, index: true
    end
  end
end
