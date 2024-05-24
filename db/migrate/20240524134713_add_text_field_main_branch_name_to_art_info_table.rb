class AddTextFieldMainBranchNameToArtInfoTable < ActiveRecord::Migration[7.1]
  def change
    add_column :art_infos, :main_branch_name, :string
  end
end
