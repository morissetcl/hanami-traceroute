# frozen_string_literal: true
require "rake"
include Rake::DSL

desc 'Prints out unused routes and unreachable action methods'
task hanami_traceroute: :environment do
  traceroute = HanamiTraceroute

  unless ENV['UNREACHABLE_ACTION_METHODS_ONLY']
    puts "Unused routes (#{traceroute.unreachable_action_methods.count}):"
    traceroute.unreachable_action_methods.each { |route| puts "  #{route}" }
  end

  unless ENV['UNUSED_ROUTES_ONLY']
    puts "Unreachable action methods (#{traceroute.unused_routes.count}):"
    traceroute.unused_routes.each { |route| puts "  #{route}" }
  end
end

namespace :hanami_traceroute do
  desc 'Prints out unused routes'
  task :unused_routes => :environment do
    ENV['UNUSED_ROUTES_ONLY'] = '1'
    Rake::Task[:hanami_traceroute].invoke
  end

  desc 'Prints out unreachable action methods'
  task :unreachable_action_methods => :environment do
    ENV['UNREACHABLE_ACTION_METHODS_ONLY'] = '1'
    Rake::Task[:hanami_traceroute].invoke
  end
end
