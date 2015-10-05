class ComentarioController < ApplicationController
  def add
      @comentario = Comentario.new
  end

  def show
    @comentario = Comentario.new
  end

def create
    #@comentario = Comentario.create(comentario_params)
    #@comentario = current_user.comentario.new(comentario_params)
    #@comentario.foto = @foto
    @comentario = comentario_params
    Comentario.comentar(@comentario[:ID_USUARIO],@comentario[:COMENTARIO],@comentario[:PUNTAJE_ASIGNADO],@comentario[:ID_FOTO])

    #@comentario.save
   redirect_to @comentario.foto
end
  def destroy
  end
  private

  def set_foto
    @foto = Foto.find(params[:ID_USUARIO])
  end

  def set_comentario
    @comentario = Comentario.find(params[:id])
  end

  def comentario_params
    params.require(:comentario).permit(:COMENTARIO, :PUNTAJE_ASIGNADO, :ID_USUARIO, :ID_FOTO)
  end
end
