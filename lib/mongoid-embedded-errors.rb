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
      self.relations.each do |name, metadata|
        # name is something like pages or sections
        nested_attr = self.nested_attributes.keys.map{ |atr| atr.gsub("_attributes","") }
        embedded_rel = self.embedded_relations.keys
        # checking all relations, which defined as 'accepts_nested_attributes_for'
        # or embedded document
        if nested_attr.include?(name) || embedded_rel.include?(name)
          # if there is an 'is invalid' message for the relation then let's work it:
          if errs[name]
            # first delete the unless 'is invalid' error for the relation
            errs.delete(name.to_sym)
            # next, loop through each of the relations (pages, sections, etc...)
            [self.send(name)].flatten.reject(&:nil?).each_with_index do |rel, i|
              # get each of their individual message and add them to the parent's errors:
              if rel.errors.any?
                rel.errors.messages.each do |k, v|
                  metadata = rel.try(:metadata)
                  metadata ||= rel.__metadata
                  if metadata.relation == Mongoid::Relations::Embedded::Many ||
                    metadata.relation == Mongoid::Relations::Referenced::Many

                    key = ("#{name}[#{i}].#{k}").to_sym
                  else
                    key = ("#{name}.#{k}").to_sym
                  end
                  errs.delete(key)
                  errs[key] = v
                  errs[key].flatten!
                end
              end
            end
          end
        end
      end
      return errs
    end

  end
end
