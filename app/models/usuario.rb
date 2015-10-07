class Usuario < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_many :comentarios, dependent: :destroy
	has_many :fotos, dependent: :destroy
	has_many :golds, dependent: :destroy
  has_many :amigos, dependent: :destroy
	#accepts_nested_attributes_for :golds

	#validates :nombre, presence: true, length: {maximum: 20}
	#validates :apellido, presence: true, length: {maximum: 20}
	#validates :nick, presence: true, length: {maximum: 20}
end
