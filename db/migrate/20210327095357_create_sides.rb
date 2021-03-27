class CreateSides < ActiveRecord::Migration[6.0]
  def change
    create_table :sides do |t|
      t.string :name
      t.references :album, null: false, foreign_key: true

      t.timestamps
    end
  end
end
