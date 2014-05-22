class RenameEventConferencePeoplePersonIdToConferencePersonId < ActiveRecord::Migration
  def change
    rename_column :event_conference_people, :person_id, :conference_person_id
  end
end
