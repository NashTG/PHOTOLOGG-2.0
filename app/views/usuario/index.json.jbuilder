json.array!(@usuarios) do |usuario|
  json.extract! usuario, :id, :nombre, :correo
  json.url usuario_url(usuario, format: :json)
end
