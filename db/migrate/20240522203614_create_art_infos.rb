class CreateArtInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :art_infos do |t|
      t.text :key
      t.string :repo_path
      t.boolean :recurring
      t.boolean :degrade
      t.boolean :random

      t.timestamps
    end
  end
end
