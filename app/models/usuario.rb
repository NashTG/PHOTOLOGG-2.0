class Usuario < ActiveRecord::Base
  self.table_name = "usuario"
  has_many :foto
  has_many :comentario

  validates :CONTRASENA, presence: {:message => "No puede estar vacio"}, length: {minimum: 6, :message => "Debe tener al menos 6 caracteres."}
	validates :CORREO, presence: {:message => "No puede estar vacio"}, :uniqueness => {:message => "Ya existe una cuenta con este correo."}
	validates :NOMBRE, presence: {:message => "No puede estar vacio"}
	validates :APELLIDO, presence: {:message => "No puede estar vacio"}
	validates :NICK, presence: {:message => "No puede estar vacio"}
  def authenticate(contrasena)
    sql = "Call mostrarContrasena(#{self.ID_USUARIO})"
    pass = ActiveRecord::Base.connection.exec_query(sql)
		if ((pass.rows.first.first).eql? contrasena)
			return true
		else
			return false
		end
	end
end

