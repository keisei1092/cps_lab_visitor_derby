class AddUserNameToPeoPle < ActiveRecord::Migration
  def change
    add_column :people, :user_name, :string
  end
end
