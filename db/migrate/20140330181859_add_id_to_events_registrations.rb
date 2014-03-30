class AddIdToEventsRegistrations < ActiveRecord::Migration
  def change
    add_column :events_registrations, :id, :primary_key
  end
end
