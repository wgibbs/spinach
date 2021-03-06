require 'aruba/api'

class ShowStepSourceLocation < Spinach::FeatureSteps

  feature "Show step source location"

  include Integration::SpinachRunner

  Given "I have a feature that has no error or failure" do
    write_file('features/success_feature.feature',
     'Feature: A success feature

      Scenario: This is scenario will succeed
        Then I succeed
     ')
    write_file('features/steps/success_feature.rb',
    'class ASuccessFeature < Spinach::FeatureSteps
      feature "A success feature"
      Then "I succeed" do
      end
     end')
    @feature = "features/success_feature.feature"
  end

  When "I run it" do
    run_feature @feature
  end

  Then "I should see the source location of each step of every scenario" do
    all_stdout.must_match(
      /I succeed.*features\/steps\/success_feature\.rb.*3/
    )
  end

  Given "I have a feature that has no error or failure and use external steps" do
    write_file('features/success_feature.feature',
     'Feature: A feature that uses external steps

      Scenario: This is scenario will succeed
        Given this is a external step
     ')
    write_file('features/steps/success_feature.rb',
    'class AFeatureThatUsesExternalSteps < Spinach::FeatureSteps
      feature "A feature that uses external steps"
      include ExternalSteps
     end')
    write_file('features/support/external_steps.rb',
    'module ExternalSteps
      include Spinach::DSL
      Given "this is a external step" do
      end
    end')
    @feature = "features/success_feature.feature"
  end

  Then "I should see the source location of each step, even external ones" do
    all_stdout.must_match(
      /this is a external step.*features\/support\/external_steps\.rb.*3/
    )
  end
end
