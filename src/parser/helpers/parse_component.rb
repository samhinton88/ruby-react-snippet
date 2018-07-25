

class ParseComponent
  # Class which reduces commmand line string into config hash
  # to create a React / Redux component
  attr_reader :raw_command, :dependency_map, :component_name
  attr_accessor :tokens, :types, :top_level_config, :redux_state, :dispatch, :dependencies,
                :rendered_nodes

  @@component_history = []

  def initialize(command, dependency_map = {})
    @raw_command = command
    @tokens = []
    @component_name = ''
    @types = ['react']
    @top_level_config = Hash.new(true)
    @redux_state = []
    @dispatch = []
    @dependency_map = dependency_map
    @dependencies = []
    @action_dependencies = []
    @rendered_nodes = []
  end

  def to_s
    brk = '*' * 10
    """
    #{brk}
    Component Name: #{@component_name}:
    dependencies: #{@dependencies}
    config: #{@top_level_config}
    types: #{@types}
    Redux State: #{@redux_state}
    Dispatch: #{@dispatch}
    Rendered Nodes: #{@rendered_nodes}
    #{brk}
    """
  end

  def call
    tokenise
    parse_name
    parse_type
    parse_config_obj
    link_dependencies
    self
  end

  def tokenise
    arr_by_whitespace = self.raw_command.split(' ')
    arr_by_whitespace_clean = arr_by_whitespace.map {|item| item.gsub(/\s/, '')}
    self.tokens = arr_by_whitespace_clean
  end

  def parse_name
    # expect first token to be the name of the component in capital case
    perceived_name = tokens.first

    @component_name = perceived_name
  end

  def parse_type
    case self.tokens[1]
    when '-rx'
      self.types.push('redux')
    end
  end

  def parse_config_obj
    # expect each token which follows to be configuration

    configuration = self.tokens.drop(2)

    configuration.each do |obj|
      case obj[0]
      when 's'
        configure_redux_state(obj)
      when 'd'
        configure_dispatch(obj)
      when 'r'
        configure_render(obj)
      end
    end

  end

  def link_dependencies
    self.dependencies = self.types.map { |type| self.dependency_map[type.to_sym]}

  end

  def configure_redux_state(conf_obj)
    # expect config in curly braces with state props and pieces of state
    # delineated by semicolon

    self.top_level_config['has_map_state_to_props'] = true

    options = conf_obj.split('{')[1].gsub('}', '')

    redux_state = options.split(';').map do |item|

      pair = item.split('.')
      { piece_of_state: pair[0], state_prop: pair[1] }
    end

    self.redux_state = redux_state

  end

  def configure_dispatch(conf_obj)
    # expect config in curly braces with actions
    # delineated by semicolon, actions can take arguments

    self.top_level_config['has_map_dispatch_to_props'] = true

    options = conf_obj.split('{')[1].gsub('}', '')

    dispatch = options.split(';').map do |item|
      action = item.split('(')
      args = action[1].gsub(')', '').split(',') if action[1]

      { action_name: action[0], args: args}
    end

    self.dispatch = dispatch
  end

  def configure_render(conf_obj)
    # expect named nodes / components to be delininated by semicolon if siblings
    # '>' following a node denotes parent - child relationship
    # button(onClick:actionName)
    self.top_level_config['has_configured_render_method'] = true

    siblings = extract_config(conf_obj).split(';')

    self.rendered_nodes = siblings.map do |item|
      hierarchy = item.split('>')
      process_hierarchy(hierarchy)
    end
  end

  def extract_config(obj)
    obj.split('{')[1].gsub('}', '')
  end

  def process_hierarchy(arr, count = 0, memo = {})
    memo[:node_name] = arr[0].split('(')[0]

    if arr.length != 1
      arr.shift
      memo[:children] = process_hierarchy(arr, count +=1, memo)
    end

    memo[:config] = process_node_config(arr[0])

    memo


  end

  def process_node_config(obj)

    node = obj.split('(')
    node_config = node[1].split(')')[0].gsub(')', '').split(',') if node[1]
    return nil unless node_config
    node_config.map do |item|
      config = item.split(':')
      { prop_name: config[0], prop_val: config[1] }
    end

  end
end


