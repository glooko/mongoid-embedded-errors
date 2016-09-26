require 'mongoid'
require 'mongoid/embedded_errors/version'
require 'mongoid/embedded_errors/embedded_in'

module Mongoid::EmbeddedErrors
  def self.included(klass)
    # make sure that the alias only happens once:
    unless klass.instance_methods.include?(:errors_without_embedded_errors)
      klass.alias_method_chain(:errors, :embedded_errors)
    end
  end

  def errors_with_embedded_errors
    errors_without_embedded_errors.tap do |errs|
      embedded_relations.each do |name, metadata|
        # name is something like pages or sections
        # if there is an 'is invalid' message for the relation then let's work it:
        next unless Array(public_send(name)).any?(&:invalid?)
        # first delete the unless 'is invalid' error for the relation
        errs[name].delete 'is invalid'
        errs.delete name.to_sym if errs[name].empty?
        # next, loop through each of the relations (pages, sections, etc...)
        [send(name)].flatten.reject(&:nil?).each_with_index do |rel, i|
          # get each of their individual message and add them to the parent's errors:
          next unless rel.errors.any?
          rel.errors.messages.each do |k, v|
            key = (metadata.relation == Mongoid::Relations::Embedded::Many ? "#{name}[#{i}].#{k}" : "#{name}.#{k}").to_sym
            errs.delete(key)
            errs[key] = v
            errs[key].flatten!
          end
        end
      end
    end
  end
end
