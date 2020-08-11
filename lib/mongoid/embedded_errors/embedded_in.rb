# frozen_string_literal: true

require 'mongoid/association/embedded/embedded_in'
ASSOCIATION = Mongoid::Association::Macros::ClassMethods
EMBEDS_MANY = Mongoid::Association::Embedded::EmbedsMany

module ASSOCIATION
  alias embedded_in_without_embedded_errors embedded_in
  def embedded_in(*args)
    relation = embedded_in_without_embedded_errors(*args)
    send(:include, Mongoid::EmbeddedErrors)
    relation
  end
end
