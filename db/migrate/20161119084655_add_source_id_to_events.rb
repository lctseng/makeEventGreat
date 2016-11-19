class AddSourceIdToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :source_id, :integer
  end
end
