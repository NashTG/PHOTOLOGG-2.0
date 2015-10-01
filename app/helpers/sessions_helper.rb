module SessionsHelper

  def log_in(usuario)
    session[:ID_USUARIO] = usuario.ID_USUARIO
  end

  def current_user
    @current_user ||= Usuario.find_by(ID_USUARIO: session[:ID_USUARIO])
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
  		session.delete(:ID_USUARIO)
  		@current_user = nil
  		##@usuario = nil
  	end
end
