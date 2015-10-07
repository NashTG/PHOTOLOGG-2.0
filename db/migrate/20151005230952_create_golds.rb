class CreateGolds < ActiveRecord::Migration
  def change
    create_table :golds do |t|
      t.references :usuario, index: true, foreign_key: true
      t.integer :es_gold
      t.date :vencimiento

      t.timestamps null: false
    end
  end
end
