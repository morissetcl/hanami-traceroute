require "version"

class Error < StandardError; end

class HanamiTraceroute
  load File.join(File.dirname(__FILE__), 'rakelib/hanami-traceroute.rake')

  class << self
    def unused_routes
      routes = routed_actions - defined_action_methods
      formatte(routes)
    end

    def unreachable_action_methods
      routes = defined_action_methods - routed_actions
      formatte(routes)
    end

    private

    def formatte(routes)
      routes.map do |route|
        route.gsub(controllers_path, "")
             .split("/")
             .map(&:capitalize)
             .join('#')
             .delete_suffix!('.rb')
      end
    end

    def routed_actions
      actions = collect_actions
      actions.map { |action| "#{Hanami.root}/apps/#{action.downcase.gsub("::", "/")}.rb" }
    end

    def collect_actions
      Hanami::Components['web.routes']
        .inspector
        .to_s("%{endpoint} ")
        .split
        .drop(1)
    end

    def defined_action_methods
      Dir["#{controllers_path}**/*.rb"]
    end

    def controllers_path
      "#{Hanami.root}/apps/web/controllers/"
    end
  end
end
