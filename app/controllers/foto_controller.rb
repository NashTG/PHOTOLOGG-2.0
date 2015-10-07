class FotoController < ApplicationController
  def add

  ##  ActiveRecord::Base.connection.execute("call insertarFoto()")
  end

  def show
    @foto = Foto.find(params[:id])
    @comentario = Comentario.new
    @comentario = Comentario.all
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
    @archivo = @foto[:imagen]
		@extension = (@archivo).to_s
		if['.jpg','.bmp','.png','.JPG','.BMP','.PNG'].include?(@extension)
			logger.debug "Archivo valido"
      Foto.subir(current_user.ID_USUARIO,@foto[:id])
      if @foto.save
			  flash[:success] = "Tu foto a sido subida exitosamente. "
        redirect_to root_path
      else
        flash.now[:danger] = 'El titúlo no puede ser nulo.'
  		  render 'add'
  		end
    else
			flash.now[:danger] = "El Archivo es Invalido"
			render 'add'
		end
	end
  private
  def foto_params
    params.require(:foto).permit(:TITULO,:imagen, :DESCRIPCION, :ID_USUARIO)
  end
end
