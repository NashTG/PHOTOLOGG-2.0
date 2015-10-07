class CreateComentarios < ActiveRecord::Migration
  def change
    create_table :comentarios do |t|
      t.string :comentario
      t.references :usuario, index: true, foreign_key: true
      t.integer :puntaje
      t.references :foto, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
