class Write
  def initialize(parser)
    puts 'initialized writer instance'
    @objects = parser.parsed_objects
  end

  def call
    puts 'call to writer call'
    write_dir
  end

  def write_dir
    Dir.mkdir('build')
    Dir.mkdir('build/src')
    Dir.mkdir('build/src/components')
    @objects.each do |o|
      object_string = create_string_from_object(o)

      Dir.mkdir("build/src/components/#{o.component_name}")
      File.open("build/src/components/#{o.component_name}/index.js", "w") { |io|  io.write(object_string) }
    end

  end

  def create_string_from_object(o)
    imports = create_imports(o)
    action_imports = create_action_imports(o) if o.dispatch
    component_class = create_component_class(o)
    imports + "\n" + action_imports
  end

  def create_component_class(o)
    class_name = o[:component_name]
    rendered_nodes = o[:rendered_nodes]

    javascript_method('render', ,1)

    "class #{class_name} extends Component {}"
  end

  def create_action_imports(o)
    dispatch = o.dispatch
    "import { #{ dispatch.map {|a| a[:action_name]}.join(', ') } }from '../../actions'"
  end

  def create_imports(o)
    dependencies = o.dependencies
    dispatch = o.dispatch
    rendered_nodes = o.rendered_nodes

    dep_arr = dependencies.map do |d|

      destructuring = d[:destructure] ? "{ #{d[:destructure].join(', ')} }" : ''
      import = d[:import] ? d[:import] : ''
      comma = destructuring && import ? ',' : ''
      "import #{import + comma + destructuring} from {d[:npm_name]}"
    end
    dep_arr.join("\n")
  end

  def javascript_method(name, body, indent)
    "#{indent * "\t"}#{name}() {\n\t#{body.join(indent + 1 * "\n\t")\n}"
  end

  def unpack(nodes)
    # create string representing dom
    # expect { :node_name, :config, :children }
    # config = { :prop_name, :prop_val }


  end
end
