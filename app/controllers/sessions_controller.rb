class SessionsController < ApplicationController

  def new
  end

  def create
    usuario = Usuario.find_by(CORREO: params[:session][:CORREO])
    if usuario && usuario.authenticate(params[:session][:CONTRASENA])
      log_in usuario
      redirect_to usuario
    else
      flash.now[:danger] = 'Correo o contraseña erróneos'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end