class ComentarioController < ApplicationController
  def add

  end

  def show
  end
def create
   @comentario = Comentario.new
   @comentario = params[:add]
   @comentario = Comentario.create(comentario_params)
   #sql = "call insertarFoto('"<< @current_user.ID_USUARIO <<"', '"<< @foto.TITULO <<"',  null , '"<< @foto.DESCRIPCION <<"');"
   #ActiveRecord::Base.connection.execute(sql)
   @comentario.save
   redirect_to root_path
end
  def destroy
  end
  private
  def comentario_params
    params.require(:comentario).permit(:COMENTARIO, :PUNTAJE)
  end
end
