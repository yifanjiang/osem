class RenameCompanyToAffiliation < ActiveRecord::Migration
  def change
    rename_column :conference_people, :company, :affiliation
  end
end
