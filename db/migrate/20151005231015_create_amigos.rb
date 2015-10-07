class CreateAmigos < ActiveRecord::Migration
  def change
    create_table :amigos do |t|
      t.references :usuario, index: true, foreign_key: true
      t.integer :id_amigo

      t.timestamps null: false
    end
  end
end
