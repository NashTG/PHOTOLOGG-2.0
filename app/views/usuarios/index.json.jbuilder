json.array!(@usuarios) do |usuario|
  json.extract! usuario, :id, :nick, :nombre, :apellido, :email, :contrasena
  json.url usuario_url(usuario, format: :json)
end
