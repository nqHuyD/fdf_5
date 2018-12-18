class AddActiveFieldIntoCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :active, :boolean, default: true
  end
end
