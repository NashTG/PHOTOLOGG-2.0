class AmistadController < ApplicationController
  def add
  end

  def show
  end

  def create
    @id_usuario = current_user.ID_USUARIO
		@id_amigo = params[:id_usuario]
		sql = "call insertarAmistad("<<@id_usuario<<","<<@id_amigo<<");"
		ActiveRecord::Base.connection.execute(sql)
		redirect_to '/amistad'
  end

  def destroy
    @id_usuario = current_user.ID_USUARIO
		@id_amigo = params[:id_amigo]
		sql = "call borrarAmistad("<<@id_usuario<<","<<@id_amigo<<");"
		response2 = ActiveRecord::Base.connection.select_all(sql)
		redirect_to :back

  end

  def index
		@id_usuario = current_user.ID_USUARIO.to_s
		sql = "CALL mostrarAmigos("<<@id_usuario<<");"
		response2 = ActiveRecord::Base.connection.select_all(sql)
		@amigos = response2.to_a

	end
end
