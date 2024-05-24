class AddTextFieldEmailToArtInfoTable < ActiveRecord::Migration[7.1]
  def change
    add_column :art_infos, :author_email, :string
  end
end
