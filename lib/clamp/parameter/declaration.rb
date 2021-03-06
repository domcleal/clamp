require "clamp/attribute/declaration"
require "clamp/parameter/definition"

module Clamp
  module Parameter

    module Declaration

      include Clamp::Attribute::Declaration

      def parameters
        @parameters ||= []
      end

      def has_parameters?
        !parameters.empty?
      end

      def parameter(name, description, options = {}, &block)
        Parameter::Definition.new(name, description, options).tap do |parameter|
          declare_attribute(parameter, &block)
          parameters << parameter
        end
      end

      protected

      def inheritable_parameters
        superclass_inheritable_parameters + parameters.select(&:inheritable?)
      end

      private

      def superclass_inheritable_parameters
        return [] unless superclass.respond_to?(:inheritable_parameters, true)
        superclass.inheritable_parameters
      end

    end

  end
end
