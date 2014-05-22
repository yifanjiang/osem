class RenameRegistrationPersonIdToConferencePersonId < ActiveRecord::Migration
  def change
    rename_column :registrations, :person_id, :conference_person_id
  end
end
