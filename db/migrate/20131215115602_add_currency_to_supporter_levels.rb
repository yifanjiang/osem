class AddCurrencyToSupporterLevels < ActiveRecord::Migration
  def change
    add_column :supporter_levels, :currency, :string
  end
end
