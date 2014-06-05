class ChangeCompanyToAffiliationInPeople < ActiveRecord::Migration
  def change
    rename_column :people, :company, :affiliation
  end
end
