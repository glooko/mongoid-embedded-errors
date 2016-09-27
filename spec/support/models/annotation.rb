class Annotation
  include Mongoid::Document

  embedded_in :article, inverse_of: :annotation

  field :text, type: String

  validates :text, presence: true
end
