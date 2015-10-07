json.array!(@comentarios) do |comentario|
  json.extract! comentario, :id, :comentario, :usuario_id, :puntaje, :foto_id
  json.url comentario_url(comentario, format: :json)
end
