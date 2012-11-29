require 'mongoid'
require "mongoid-embedded-errors/version"
require "mongoid-embedded-errors/embedded_in"

module Mongoid
  module EmbeddedErrors

    def self.included(klass)
      # make sure that the alias only happens once:
      unless klass.instance_methods.include?(:errors_without_embedded_errors)
        klass.alias_method_chain(:errors, :embedded_errors)
      end
    end

    def errors_with_embedded_errors
      errs = errors_without_embedded_errors
      self.embedded_relations.each do |name, metadata|
        if errs[name]
          errs.delete(name.to_sym)
          self.send(name).each do |rel|
            errs[name] = {rel.id.to_s => rel.errors.messages} if rel.errors.any?
          end
        end
      end
      return errs
    end

  end
end
