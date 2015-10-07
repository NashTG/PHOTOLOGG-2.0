require 'test_helper'

class FotosControllerTest < ActionController::TestCase
  setup do
    @foto = fotos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fotos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create foto" do
    assert_difference('Foto.count') do
      post :create, foto: { descripcion: @foto.descripcion, puntaje: @foto.puntaje, references: @foto.references, titulo: @foto.titulo }
    end

    assert_redirected_to foto_path(assigns(:foto))
  end

  test "should show foto" do
    get :show, id: @foto
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @foto
    assert_response :success
  end

  test "should update foto" do
    patch :update, id: @foto, foto: { descripcion: @foto.descripcion, puntaje: @foto.puntaje, references: @foto.references, titulo: @foto.titulo }
    assert_redirected_to foto_path(assigns(:foto))
  end

  test "should destroy foto" do
    assert_difference('Foto.count', -1) do
      delete :destroy, id: @foto
    end

    assert_redirected_to fotos_path
  end
end
