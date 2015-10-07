class FotosController < ApplicationController
  before_action :set_foto, only: [:show, :edit, :update, :destroy]

  # GET /fotos
  # GET /fotos.json
  def index
    @fotos = Foto.all
  end

  # GET /fotos/1
  # GET /fotos/1.json
  def show
    @comentario = Comentario.new
  end

  def mias
    @fotos = Foto.all
  end

  def sus_fotos
    @fotos = Foto.all
    @amigo = Amigo.all
  end
  # GET /fotos/new
  def new
    @foto = Foto.new
  end

  # GET /fotos/1/edit
  def edit
  end

  # POST /fotos
  # POST /fotos.json
  def create
    #@foto = Foto.new(foto_params)

    #if current_usuario != nil
    if current_usuario.tipo_usuario == 0
        sql = "update usuarios set f_restantes = 0 where id = #{current_usuario.id}";
        ActiveRecord::Base.connection.execute(sql)
    end
    @foto = current_usuario.fotos.new(foto_params)
    respond_to do |format|
      if @foto.save
        format.html { redirect_to @foto, notice: 'Foto subida correctamente.' }
        format.json { render :show, status: :created, location: @foto }
      else
        format.html { render :new }
        format.json { render json: @foto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fotos/1
  # PATCH/PUT /fotos/1.json
  def update
    respond_to do |format|
      if @foto.update(foto_params)
        format.html { redirect_to @foto, notice: 'Foto actualizada correctamente.' }
        format.json { render :show, status: :ok, location: @foto }
      else
        format.html { render :edit }
        format.json { render json: @foto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fotos/1
  # DELETE /fotos/1.json
  def destroy
    @foto = Foto.find(params[:id])
    @foto.destroy
    respond_to do |format|
      format.html { redirect_to mias_path, notice: 'Foto eliminada correctamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_foto
      @foto = Foto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def foto_params
      params.require(:foto).permit(:titulo, :descripcion, :puntaje, :references,:imagen,:usuario_id)
    end
end
