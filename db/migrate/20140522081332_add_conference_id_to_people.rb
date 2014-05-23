class AddConferenceIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :conference_id, :integer
  end
end
