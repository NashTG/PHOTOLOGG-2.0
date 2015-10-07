class GoldsController < ApplicationController
  before_action :set_gold, only: [:show, :edit, :update, :destroy]
  before_action :set_usuario
  # GET /golds
  # GET /golds.json
  def index
    @golds = Gold.all
  end

  # GET /golds/1
  # GET /golds/1.json
  def show
  end

  # GET /golds/new
  def new
    @gold = Gold.new
  end

  # GET /golds/1/edit
  def edit
  end

  # POST /golds
  # POST /golds.json
  def create

    @gold = current_usuario.golds.new()
    @gold = Gold.new()
    @gold.usuario = @usuario
    @usuario.tipo_usuario = 1
    respond_to do |format|
      if @gold.save && @usuario.save

        format.html { redirect_to @gold.usuario, notice: 'Ahora eres Gold!!.' }
        format.json { render :show, status: :created, location: @gold }
      else
        format.html { render :new }
        format.json { render json: @gold.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /golds/1
  # PATCH/PUT /golds/1.json
  def update
    respond_to do |format|
      if @gold.update(gold_params)
        format.html { redirect_to @gold.usuario, notice: 'Gold was successfully updated.' }
        format.json { render :show, status: :ok, location: @gold }
      else
        format.html { render :edit }
        format.json { render json: @gold.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /golds/1
  # DELETE /golds/1.json
  def destroy
    @gold.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Gold was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gold
      @gold = Gold.find(params[:id])
    end

    def set_usuario
      @usuario = Usuario.find(params[:usuario_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gold_params
      params.require(:gold).permit(:usuario_id, :es_gold, :vencimiento)
    end
end
