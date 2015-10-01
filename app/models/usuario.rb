class Usuario < ActiveRecord::Base
  self.table_name = "USUARIO"

  def authenticate(contrasena)
		if ((self.CONTRASENA).eql? contrasena)
			return true
		else
			return false
		end
	end
end
