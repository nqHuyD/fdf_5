class AddSocialImagesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :social_img, :string
  end
end
