class AddImagenToFoto < ActiveRecord::Migration
  def change
  	add_attachment :fotos, :imagen
  end
end
