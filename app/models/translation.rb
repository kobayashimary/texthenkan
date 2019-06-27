class Translation < ApplicationRecord
  belongs_to :document ,class_name: 'Document', foreign_key: "document_id"
  validates :language, presence: true
  validates :target, presence: true
end