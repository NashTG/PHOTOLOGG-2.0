class AddImageToFoto < ActiveRecord::Migration
  def change
  	add_attachment :foto, :imagen
  end
end
