class AddCreatedAtInEventsRegistrations < ActiveRecord::Migration
  def change
    add_column :events_registrations, :created_at, :datetime
  end
end
