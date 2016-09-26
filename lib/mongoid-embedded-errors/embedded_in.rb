require 'mongoid/relations/embedded/in'

module Mongoid
  module Relations
    module Macros
      module ClassMethods
        alias embedded_in_without_embedded_errors embedded_in
        def embedded_in(*args)
          relation = embedded_in_without_embedded_errors(*args)
          send(:include, Mongoid::EmbeddedErrors)
          relation
        end
      end
    end
  end
end
