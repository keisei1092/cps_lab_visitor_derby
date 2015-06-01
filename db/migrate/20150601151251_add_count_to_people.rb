class AddCountToPeople < ActiveRecord::Migration
  def change
    add_column :people, :count, :integer
  end
end
