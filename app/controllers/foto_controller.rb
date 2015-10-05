class FotoController < ApplicationController
  def add

  ##  ActiveRecord::Base.connection.execute("call insertarFoto()")
  end

  def show
    @foto = Foto.find(params[:id])
    @comentario = Comentario.new
    @comentarios = Comentario.all
  end


  def index
    @foto = Foto.all

    # PAGINA DE FOTOS: FOTOS SUBIDAS SOLO DEL USUARIO
    #@foto = Foto.find_by(ID_USUARIO: current_user[:ID_USUARIO])
  end

  def destroy
  end
  def create
    @foto = Foto.new
    @foto = Foto.create(foto_params)
    Foto.subir(current_user.ID_USUARIO,@foto[:id])
    @foto.save
    redirect_to root_path
	end

  private
  def foto_params
    params.require(:foto).permit(:TITULO,:imagen, :DESCRIPCION, :ID_USUARIO)
  end
end
