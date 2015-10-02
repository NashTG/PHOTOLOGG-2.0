class AuditoriaController < ApplicationController

  def index
  	@auditorias = Auditoria.all
  end

end
