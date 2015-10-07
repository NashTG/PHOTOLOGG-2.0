json.array!(@golds) do |gold|
  json.extract! gold, :id, :usuario_id, :es_gold, :vencimiento
  json.url gold_url(gold, format: :json)
end
