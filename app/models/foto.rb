class Foto < ActiveRecord::Base
	has_many :comentarios, dependent: :destroy
	belongs_to :usuario
	validates :titulo, presence: true, length: {maximum: 200, minimum: 6}
	validates :descripcion, presence: true, length: {maximum: 200, minimum: 6}

	has_attached_file :imagen, styles:{normal: "700x700", thumb: "300x300", peque: "100x100"}
	  validates_attachment_content_type :imagen, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
	  validates_attachment_file_name :imagen, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]
end

