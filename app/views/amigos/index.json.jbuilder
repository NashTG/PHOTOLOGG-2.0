json.array!(@amigos) do |amigo|
  json.extract! amigo, :id, :usuario_id, :id_amigo
  json.url amigo_url(amigo, format: :json)
end
