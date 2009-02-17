require 'cucover'
require 'cucumber'

module Cucover
  module Cli
    class Main < Cucumber::Cli::Main
      class << self
        def execute(args)
          new(['features', '--format', 'Cucover::Formatter::Lazy', '--require', Cucover::LIB + '/formatter/lazy']).execute!(@step_mother)
        end
      end
      
      def execute!(step_mother)
        configuration.load_language
        step_mother.options = configuration.options

        require_files
        enable_diffing
      
        features = load_plain_text_features

        visitor = configuration.build_formatter_broadcaster(step_mother)
        visitor.visit_features(features)
      
        failure = features.steps[:failed].any? || (configuration.strict? && features.steps[:undefined].length)
        Kernel.exit(failure ? 1 : 0)
      end
      
    end
  end
end

Cucover::Cli::Main.step_mother = self