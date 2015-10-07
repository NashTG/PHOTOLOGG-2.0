class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios do |t|
      t.string :nick
      t.string :nombre
      t.string :apellido
      t.string :email
      t.string :contrasena

      t.timestamps null: false
    end
  end
end
