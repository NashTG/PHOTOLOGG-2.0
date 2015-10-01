class UsuarioController < ApplicationController
  def add
    @usuario = Usuario.new
    #ActiveRecord::Base.connection.execute("call insertarUsuario()")
  end

  def show
    @usuario = Usuario.find(params[:id])
  end

  def create
		@usuario = Usuario.create(usuario_params)
    #sql= "CALL insertarUsuario('"<<@usuario.NICK.to_s<<"','"<<@usuario.CONTRASENA.to_s<<"','"<<@usuario.NOMBRE.to_s<<"','"<<@usuario.APELLIDO.to_s<<"','"<<@usuario.CORREO.to_s<<"',0)"
		if @usuario.save
			log_in @usuario
			flash[:success] = "Bienvenido a Photolog!"
  			redirect_to @usuario
  		else
  			render new
  		end
	end

  def destroy
  end

    private
    def usuario_params
      params.require(:usuario).permit(:NICK, :CORREO, :CONTRASENA, :NOMBRE, :APELLIDO)
    end

  end
