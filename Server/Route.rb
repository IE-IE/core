class Route
  @@routes = {
    'GET' => {
      '/api/chitin/filetypes' => 'API#chitin',
      '/api/chitin/files/:type' => 'API#chitin',
      '/api/chitin/full' => 'API#chitin_full',
      '/api/chitin/set' => 'API#chitin_set' # ?location=...
    },
    'POST' => {

    }
  }

  def initialize( request )
    route, params = compare_route( request.path, request.request_method )
    target = @@routes[request.request_method][route].split('#')

    @class  = target[0]
    @method = target[1]
    @params = params
  end

  def compare_route( path, method )
    routes = @@routes[method]
    found_route = ''
    params = {}

    routes.keys.each do |route|
      regexp_route = route_to_regexp(route)
      regexp = Regexp.new( '^' + regexp_route + '$' )

      if( match = regexp.match(path) )
        found_route = route
        params = Hash[match.names.zip(match.captures)]
        break
      end
    end

    [ found_route, params ]
  end

  def route_to_regexp( route )
    new_route = []

    # Change :param names in routes into named (?<name>) regexp expressions
    route.split('/').each_with_index do |el, index|
      if( el.to_s[0] == ':' )
        name = el[1..-1]
        el = '(?<' + name+ '>\w+||\d+)'
      end

      new_route << el
    end

   new_route.join('/')
  end

  def get_class
    @class
  end

  def get_method
    @method
  end

  def get_params
    @params
  end
end