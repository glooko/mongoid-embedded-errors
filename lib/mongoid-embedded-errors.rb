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
        # name is something like pages or sections
        # if there is an 'is invalid' message for the relation then let's work it:
        if errs[name]
          # first delete the unless 'is invalid' error for the relation
          errs.delete(name.to_sym)
          # next, loop through each of the relations (pages, sections, etc...)
          self.send(name).each_with_index do |rel, i|
            # get each of their individual message and add them to the parent's errors:
            if rel.errors.any?
              rel.errors.messages.each do |k, v|
                key = "#{name}[#{i}].#{k}".to_sym
                errs.delete(key)
                errs[key] = v
                errs[key].flatten!
              end
            end
          end
        end
      end
      return errs
    end

  end
end
