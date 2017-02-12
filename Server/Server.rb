class Server < WEBrick::HTTPServlet::AbstractServlet
  @@root = 'public'
  @@wd = './Server'

  def do_GET( request, response )
    proceed( request, response )
  end

  def do_POST( request, response )
    proceed( request, response )
  end

  def proceed( request, response )
    load File.join( @@wd, 'Route.rb' )
    route = Route.new( request )

    instance = create_instance( route, request.query )
    instance.send( route.get_method )

    respond( route, instance, response )
  end

  def create_instance( route, params )
    load File.join( @@wd, 'app', route.get_class + '.rb')
    object = Object.const_get( route.get_class ).new
    object.params = params.merge( route.get_params )

    object
  end

  def render( route, instance )
    instance_binding = instance.get_binding

    if( instance.render )
      to_render = instance.render
      instance.render = nil
    else
      to_render = route.get_method
    end

    view = File.join(@@wd, 'views', route.get_class, to_render + '.erb')
    view = File.read( view )
    template = ERB.new( view )
    result = template.result( instance_binding )
  end

  def respond( route, instance, response )
    response.body = render( route, instance )
    response.status = 200
    response['Content-Type'] = 'application/json'
  end

  def self.root
    @@root
  end
end