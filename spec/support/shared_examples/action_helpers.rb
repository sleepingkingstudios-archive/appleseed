# spec/support/shared_examples/action_helpers.rb

module Appleseed
  module SharedExamples
    module ActionHelpers
      RESTFUL_ACTIONS = %w(index new create show edit update destroy)

      def filter_actions actions, options
        if !options[:only].blank?
          options[:only] = [options[:only]].flatten unless options[:only].is_a?(Array)
          actions.select { |action| options[:only].include?(action.to_s.intern) }
        elsif !options[:except].blank?
          options[:except] = [options[:except]].flatten unless options[:except].is_a?(Array)
          actions.select { |action| !options[:except].include?(action.to_s.intern) }
        else
          actions
        end # if-elsif-else
      end # class method filter_actions
    end # module
  end # module
end # module
