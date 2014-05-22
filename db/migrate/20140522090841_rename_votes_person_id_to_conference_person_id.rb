class RenameVotesPersonIdToConferencePersonId < ActiveRecord::Migration
  def change
    rename_column :votes, :person_id, :conference_person_id
  end
end
