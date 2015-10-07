class Amistad < ActiveRecord::Base
  self.table_name = "amistad"

  belongs_to :bestfriender, class_name: "Usuario"
  belongs_to :bestfriended, class_name: "Usuario"

  validates :bestfriender_id, presence: true
  validates :bestfriended_id, presence: true

  add_index :amistad, :bestfriender_id
  add_index :amistad, :bestfriended_id
  add_index :amistad, [:bestfriender_id, :besfriended_id], unique: true


end
