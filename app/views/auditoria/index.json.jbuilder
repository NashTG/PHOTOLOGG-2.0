json.array!(@auditoria) do |auditorium|
  json.extract! auditorium, :id, :usuario_id, :accion, :old, :new, :ts
  json.url auditorium_url(auditorium, format: :json)
end
