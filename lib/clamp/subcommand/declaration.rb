require 'clamp/subcommand'

module Clamp
  class Subcommand

    module Declaration

      def recognised_subcommands
        @recognised_subcommands ||= []
      end

      def subcommand(name, description, subcommand_class = self, &block)
        unless has_subcommands?
          @subcommand_parameter = if @default_subcommand
            parameter "[SUBCOMMAND]", "subcommand", :attribute_name => :subcommand_name, :default => @default_subcommand
          else
            parameter "SUBCOMMAND", "subcommand", :attribute_name => :subcommand_name, :required => false
          end
          remove_method :default_subcommand_name
          parameter "[ARG] ...", "subcommand arguments", :attribute_name => :subcommand_arguments
        end
        if block
          # generate a anonymous sub-class
          subcommand_class = Class.new(subcommand_class, &block)
        end
        recognised_subcommands << Subcommand.new(name, description, subcommand_class)
      end

      def has_subcommands?
        !recognised_subcommands.empty?
      end

      def find_subcommand(name)
        recognised_subcommands.find { |sc| sc.is_called?(name) }
      end

      def parameters_before_subcommand
        parameters.take_while { |p| p != @subcommand_parameter }
      end

      attr_writer :default_subcommand

      def default_subcommand(*args, &block)
        if args.empty?
          @default_subcommand ||= nil
        else
          $stderr.puts "WARNING: Clamp default_subcommand syntax has changed; check the README."
          $stderr.puts "  (from #{caller.first})"
          self.default_subcommand = args.first
          subcommand(*args, &block)
        end
      end

    end

  end
end
