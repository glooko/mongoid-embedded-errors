# frozen_string_literal: true

class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::EmbeddedErrors

  embeds_many :pages
  embeds_one :annotation

  field :name, type: String
  field :summary, type: String

  validates :name, presence: true
  validates :summary, presence: true
  validates :pages, presence: true
end
