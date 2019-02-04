require 'mongoid-compatibility'

if Mongoid::Compatibility::Version.mongoid7_or_newer?
  require 'mongoid/association/embedded/embedded_in'
  ASSOCIATION = Mongoid::Association::Macros::ClassMethods
  EMBEDS_MANY = Mongoid::Association::Embedded::EmbedsMany
else
  require 'mongoid/relations/embedded/in'
  ASSOCIATION = Mongoid::Relations::Macros::ClassMethods
  EMBEDS_MANY = Mongoid::Relations::Embedded::Many
end

module ASSOCIATION
  alias embedded_in_without_embedded_errors embedded_in
  def embedded_in(*args)
    relation = embedded_in_without_embedded_errors(*args)
    send(:include, Mongoid::EmbeddedErrors)
    relation
  end
end
