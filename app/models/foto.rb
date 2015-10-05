class Foto < ActiveRecord::Base
  self.table_name = "foto"
  belongs_to :usuario
  has_many :comentario
  has_attached_file :imagen, styles:{normal: "900x900", thumb: "300x300", peque: "100x100"}
  validates_attachment_content_type :imagen, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_file_name :imagen, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]

  def self.subir(idu,idf)
    self.connection.execute("UPDATE foto SET id_usuario=#{idu} WHERE id_foto=#{idf};")
    self.connection.execute("DELETE FROM auditoria WHERE id_auditoria ORDER BY id_auditoria DESC LIMIT 1;")
  end

end
