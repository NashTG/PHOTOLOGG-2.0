class Foto < ActiveRecord::Base
  self.table_name = "FOTO"
  belongs_to :usuario
  has_many :comentario
end
