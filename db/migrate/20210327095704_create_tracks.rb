class CreateTracks < ActiveRecord::Migration[6.0]
  def change
    create_table :tracks do |t|
      t.integer :number
      t.string :title
      t.string :length
      t.references :side, null: false, foreign_key: true
      t.references :album, null: false, foreign_key: true

      t.timestamps
    end
  end
end
