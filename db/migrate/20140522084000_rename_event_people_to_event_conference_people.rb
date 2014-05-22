class RenameEventPeopleToEventConferencePeople < ActiveRecord::Migration
  def change
    rename_table :event_people, :event_conference_people
  end
end
