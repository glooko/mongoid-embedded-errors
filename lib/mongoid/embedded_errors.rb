# frozen_string_literal: true

require 'mongoid'
require 'mongoid/embedded_errors/version'
require 'mongoid/embedded_errors/embedded_in'

module Mongoid::EmbeddedErrors
  def self.included(klass)
    return if klass.instance_methods.include?(:errors_without_embedded_errors)

    klass.public_send :alias_method, :errors_without_embedded_errors, :errors
    klass.public_send :alias_method, :errors, :errors_with_embedded_errors
  end

  def errors_with_embedded_errors
    errors_without_embedded_errors.tap do |errs|
      embedded_relations.each do |name, metadata|
        # first delete the unless 'is invalid' error for the relation
        next unless Array(public_send(name)).any? { |doc| doc.errors.any? }

        errs[name].delete 'is invalid'
        errs.delete name.to_sym if errs[name].empty?

        # next, loop through each of the relations (pages, sections, etc...)
        [public_send(name)].flatten.reject(&:nil?).each_with_index do |rel, i|
          next unless rel.errors.any?

          # get each of their individual message and add them to the parent's errors:
          rel.errors.each do |k, v|
            relation = metadata.class
            key = if relation.equal? EMBEDS_MANY
                    "#{name}[#{i}].#{k}"
                  else
                    "#{name}.#{k}"
                  end.to_sym
            errs.delete(key)
            errs.add key, v if v.present?
          end
        end
      end
    end
  end
end
