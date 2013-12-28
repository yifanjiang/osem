class AddPriceToSupporterLevels < ActiveRecord::Migration
  def change
    add_column :supporter_levels, :price, :float
  end
end
