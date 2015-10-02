class Comentario < ActiveRecord::Base
  self.table_name = "comentario"
  belongs_to :usuario
  belongs_to :foto
end

