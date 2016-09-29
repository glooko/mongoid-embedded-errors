require 'mongoid/relations/embedded/in'

module Mongoid::Relations::Macros::ClassMethods
  alias embedded_in_without_embedded_errors embedded_in
  def embedded_in(*args)
    relation = embedded_in_without_embedded_errors(*args)
    send(:include, Mongoid::EmbeddedErrors)
    relation
  end
end
