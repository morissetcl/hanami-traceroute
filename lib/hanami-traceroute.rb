require "version"

class Error < StandardError; end

class HanamiTraceroute
  load File.join(File.dirname(__FILE__), 'rakelib/hanami-traceroute.rake')

  def initialize(app)
  @app = app
  # @ignored_unreachable_actions = []
  # @ignored_unused_routes = [/^\/cable$/]
  #
  # # @ignored_unused_routes << %r{^#{@app.config.assets.prefix}} if @app.config.respond_to? :assets
  #
  # # config_filename = %w(.traceroute.yaml .traceroute.yml .traceroute).detect {|f| File.exist?(f)}
  # # if config_filename && (config = YAML.load_file(config_filename))
  # #   (config['ignore_unreachable_actions'] || []).each do |ignored_action|
  # #     @ignored_unreachable_actions << Regexp.new(ignored_action)
  # #   end
  # #
  # #   (config['ignore_unused_routes'] || []).each do |ignored_action|
  # #     @ignored_unused_routes << Regexp.new(ignored_action)
  # #   end
  # # end
  # result = routed_actions - defined_action_methods
  end

  def unused_routes
    routes = routed_actions - defined_action_methods
    formatte(routes)
  end

  def unreachable_action_methods
    routes = defined_action_methods - routed_actions
    formatte(routes)
  end

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
    formatter = "%{endpoint} "
    actions = Hanami::Components['web.routes']
      .inspector
      .to_s(formatter)
      .split
      .drop(1)

    actions.map { |action| "#{Hanami.root}/apps/#{action.downcase.gsub("::", "/")}.rb" }
  end

  def defined_action_methods
    Dir["#{controllers_path}**/*.rb"]
  end

  def controllers_path
    "#{Hanami.root}/apps/web/controllers/"
  end
end
