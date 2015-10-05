class UsuarioController < ApplicationController
  def add
    @usuario = Usuario.new

    #ActiveRecord::Base.connection.execute("call insertarUsuario()")
  end

  def show
    if logged_in?
      @usuario = Usuario.find(current_user.ID_USUARIO)
      render 'show'
    else
      redirect_to root_path

    end
  end

  def auditoria
    if logged_in?
      if current_user.TIPO_USUARIO == 2
        #@usuario = Usuario.find(current_user.ID_USUARIO)
        @auditoria = Auditoria.all
        #render 'auditoria'
      end
    else
      redirect_to '/'
    end
  end

  def index
    @usuario = Usuario.all
  end

  def editar
    @usuario = Usuario.find(current_user.ID_USUARIO)
    render 'editar'
  end

  def create
		@usuario = Usuario.create(usuario_params)
    #sql= "CALL insertarUsuario('"<<@usuario.NICK.to_s<<"','"<<@usuario.CONTRASENA.to_s<<"','"<<@usuario.NOMBRE.to_s<<"','"<<@usuario.APELLIDO.to_s<<"','"<<@usuario.CORREO.to_s<<"',0)"
		if @usuario.save
			log_in @usuario
			flash[:success] = "Bienvenido a Photolog!"
  		redirect_to @usuario
  		else
        flash.now[:danger] = 'Registro no completado.'
  			redirect_to root_path
  		end
	end

  def destroy
    @usuario = params[:id]
    #id = usuario.ID_USUARIO
    sql = "call borrarUsuario(#{@usuario});"
    ActiveRecord::Base.connection.execute(sql)
    ActiveRecord::Base.clear_active_connections!
    redirect_to listar_cuentas_path
  end

    private
    def usuario_params
      params.require(:usuario).permit(:NICK, :CORREO, :CONTRASENA, :NOMBRE, :APELLIDO)
    end

  end
