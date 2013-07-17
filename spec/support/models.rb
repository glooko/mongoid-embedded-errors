class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::EmbeddedErrors

  field :name, type: String
  field :summary, type: String

  validates :name, presence: true
  validates :summary, presence: true

  embeds_many :pages
  embeds_one :annotation
end

class Page
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String

  validates :title, presence: true

  embedded_in :article, inverse_of: :pages
  embeds_many :sections
end

class Section
  include Mongoid::Document
  include Mongoid::Timestamps

  field :header, type: String
  field :body, type: String

  validates :header, presence: true

  embedded_in :page, inverse_of: :sections
end

class Annotation
  include Mongoid::Document

  embedded_in :article, inverse_of: :annotation

  field :text, type: String

  validates :text, presence: true

end