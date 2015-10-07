class CreateAuditoria < ActiveRecord::Migration
  def change
    create_table :auditoria do |t|
      t.integer :usuario_id
      t.string :accion
      t.string :old
      t.string :new
      t.timestamp :ts

      t.timestamps null: false
    end
  end
end
