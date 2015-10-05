class Comentario < ActiveRecord::Base
  self.table_name = "comentario"
  belongs_to :usuario
  belongs_to :foto

  def self.comentar(idf,comentario,ptje,idu)
    self.connection.execute("call insertarComentario(#{idf},'"<<comentario<<"',#{ptje},#{idu});")
  
  end

end
