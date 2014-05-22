class RenamePeopleToConferencePeople < ActiveRecord::Migration
  def change
    rename_table :people, :conference_people
  end
end
