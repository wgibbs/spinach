require 'aruba/api'

module Integration
  module SpinachRunner
    include Aruba::Api

    def self.included(base)
      Spinach.hooks.before_scenario do
        @aruba_timeout_seconds = 6
        if respond_to?(:in_current_dir)
          in_current_dir do
            run "rm -fR rails_app"
          end
        end
      end
    end

    def run_feature(command, options={})
      options[:suite] ||= :minitest
      use_minitest if options[:suite] == :minitest
      use_rspec if options[:suite] == :rspec
      run "../../bin/spinach #{command} #{options[:append]}"
    end

    def use_minitest
      write_file('features/support/minitest.rb',
                "require 'minitest/spec'")
    end

    def use_rspec
      write_file('features/support/minitest.rb',
                "require 'rspec'")
    end
  end
end
