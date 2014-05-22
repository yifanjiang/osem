class AddConferenceIdToConferencePeople < ActiveRecord::Migration
  def change
    add_column :conference_people, :conference_id, :integer
  end
end
