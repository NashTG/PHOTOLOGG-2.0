class AddColumnToUsuario < ActiveRecord::Migration
  def change
  	  	add_column :usuarios, :tipo_usuario, :integer, :default => 0
  end
end
