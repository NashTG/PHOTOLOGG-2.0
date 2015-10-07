class CreateFotos < ActiveRecord::Migration
  def change
    create_table :fotos do |t|
      t.string :titulo
      t.string :descripcion
      t.integer :puntaje
      t.references :usuario

      t.timestamps null: false
    end
  end
end
