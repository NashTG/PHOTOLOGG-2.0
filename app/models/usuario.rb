class Usuario < ActiveRecord::Base
  self.table_name = "usuario"

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
