json.array!(@fotos) do |foto|
  json.extract! foto, :id, :titulo, :descripcion, :puntaje, :references
  json.url foto_url(foto, format: :json)
end
