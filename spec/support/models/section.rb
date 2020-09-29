# frozen_string_literal: true

class Section
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :page, inverse_of: :sections

  field :header, type: String
  field :body, type: String

  validates :header, presence: true
end
