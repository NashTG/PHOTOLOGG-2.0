class Comentario < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :foto
  validates :comentario, presence: true, length: {maximum: 1000, minimum: 6}
end
