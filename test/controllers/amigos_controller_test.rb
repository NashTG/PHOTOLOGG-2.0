require 'test_helper'

class AmigosControllerTest < ActionController::TestCase
  setup do
    @amigo = amigos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:amigos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create amigo" do
    assert_difference('Amigo.count') do
      post :create, amigo: { id_amigo: @amigo.id_amigo, usuario_id: @amigo.usuario_id }
    end

    assert_redirected_to amigo_path(assigns(:amigo))
  end

  test "should show amigo" do
    get :show, id: @amigo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @amigo
    assert_response :success
  end

  test "should update amigo" do
    patch :update, id: @amigo, amigo: { id_amigo: @amigo.id_amigo, usuario_id: @amigo.usuario_id }
    assert_redirected_to amigo_path(assigns(:amigo))
  end

  test "should destroy amigo" do
    assert_difference('Amigo.count', -1) do
      delete :destroy, id: @amigo
    end

    assert_redirected_to amigos_path
  end
end
