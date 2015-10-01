class UsuarioController < ApplicationController
  def add
    @usuario = Usuario.new
    #ActiveRecord::Base.connection.execute("call insertarUsuario()")
  end

  def show
    @usuario = Usuario.find(params[:id])
  end

  def destroy
  end
end
