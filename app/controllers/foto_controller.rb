class FotoController < ApplicationController
  def add

  ##  ActiveRecord::Base.connection.execute("call insertarFoto()")
  end

  def show
    @foto = Foto.find(params[:id])
    @comentario = Comentario.where('ID_FOTO = ?', @foto.ID_FOTO)
  end


  def index
    @foto = Foto.all
  end

  def destroy
  end
  def create
    @foto = Foto.new
    @foto = params[:add]
    @foto = Foto.create(foto_params)
    #sql = "call insertarFoto('"<< @current_user.ID_USUARIO <<"', '"<< @foto.TITULO <<"',  null , '"<< @foto.DESCRIPCION <<"');"
    #ActiveRecord::Base.connection.execute(sql)
    @foto.save
    redirect_to root_path
	end

  private
  def foto_params
    params.require(:foto).permit(:TITULO,:FOTO, :DESCRIPCION)
  end
end
