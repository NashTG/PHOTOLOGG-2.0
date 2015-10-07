class AmigosController < ApplicationController
  before_action :set_amigo, only: [:show, :edit, :update, :destroy]
  before_action :set_usuario
  # GET /amigos
  # GET /amigos.json
  def index
    @amigos = Amigo.all
  end

  # GET /amigos/1
  # GET /amigos/1.json
  def show
  end

  # GET /amigos/new
  def new
    @amigo = Amigo.new
  end

  # GET /amigos/1/edit
  def edit
  end

  def mis_amigos

    @amigos = Amigo.all
    @fotos = Foto.all
  end

  # POST /amigos
  # POST /amigos.json
  def create
    @amigo = Amigo.new(amigo_params)

    respond_to do |format|
      if @amigo.save
        format.html { redirect_to root_path, notice: 'Ahora sigues a esta persona!.' }
        format.json { render :show, status: :created, location: @amigo }
      else
        format.html { render :new }
        format.json { render json: @amigo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /amigos/1
  # PATCH/PUT /amigos/1.json
  def update
    respond_to do |format|
      if @amigo.update(amigo_params)
        format.html { redirect_to root_path, notice: 'Amigo was successfully updated.' }
        format.json { render :show, status: :ok, location: @amigo }
      else
        format.html { render :edit }
        format.json { render json: @amigo.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /amigos/1
  # DELETE /amigos/1.json
  def destroy
    @amigo.destroy
    respond_to do |format|
      format.html { redirect_to fotos_path, notice: 'Ya no sigues a esta persona.' }
      format.json { head :no_content }
    end
  end


  private

  def set_usuario
      #@usuario = Usuario.find(params[:usuario_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_amigo
      @amigo = Amigo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def amigo_params
      params.require(:amigo).permit(:usuario_id, :id_amigo)
    end
end
