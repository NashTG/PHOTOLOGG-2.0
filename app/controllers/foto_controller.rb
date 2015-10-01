class FotoController < ApplicationController
  def add
    ActiveRecord::Base.connection.execute("call insertarFoto()")
  end

  def show
  end

  def destroy
  end
end
