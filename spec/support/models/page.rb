class Page
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :article, inverse_of: :pages
  embeds_many :sections

  field :title, type: String

  validates :title, presence: true
end
