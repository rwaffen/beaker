require 'rubygems' unless defined?(Gem)
module Beaker
  %w(version platform test_suite test_suite_result result command options network_manager cli perf logger_junit subcommand).each do |lib|
    begin
      require "beaker/#{lib}"
    rescue LoadError
      require File.expand_path(File.join(__dir__, 'beaker', lib))
    end
  end
  # These really are our sub-systems that live within the harness today
  # Ideally I would like to see them split out into modules that can be
  # included as such here
  #
  # The Testing DSL
  require 'beaker/dsl'
  #
  # Our Host Abstraction Layer
  require 'beaker/host'
  #
  # Our Hypervisor Abstraction Layer
  require 'beaker/hypervisor'
  #
  # How we manage connecting to hosts and hypervisors
  # require 'beaker/connectivity'
  #
  # Our test runner, suite, test cases and steps
  # require 'beaker/runner'
  #
  # Common setup and testing steps
  # require 'beaker/steps'

  # InParallel, for executing in parallel
  require 'in_parallel'

  # Shared methods and helpers
  require 'beaker/shared'

  # MiniTest, for including MiniTest::Assertions
  require 'minitest/test'
end
