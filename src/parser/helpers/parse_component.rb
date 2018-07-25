class ParseComponent
  # Class which reduces commmand line string into config hash
  # to create a React / Redux component
  attr_reader :raw_command
  attr_accessor :tokens, :types, :top_level_config, :redux_state, :dispatch

  @@component_history = []

  def initialize(command)
    @raw_command = command
    @tokens = []
    @component_name = ''
    @types = []
    @top_level_config = Hash.new(true)
    @redux_state = []
    @dispatch = []
  end

  def to_s
    brk = '*' * 10
    """
    #{brk}
    Component #{@component_name}:
    config: #{@top_level_config}
    types: #{@types}
    Redux State: #{@redux_state}
    Dispatch: #{@dispatch}
    #{brk}
    """
  end

  def call
    tokenise
    parse_name
    parse_type
    parse_config_obj
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
    puts 'parse_name'
    puts @component_name
  end

  def parse_type
    case self.tokens[1]
    when '-rx'
      self.types.push('redux')
    end

    puts @component_name
  end

  def parse_config_obj
    # expect each token which follows to be configuration
    puts 'parse_config_obj'
    configuration = self.tokens.drop(2)
    puts configuration
    configuration.each do |obj|
      case obj[0]
      when 's'
        configure_redux_state(obj)
      when 'd'
        configure_dispatch(obj)
      end
    end

  end

  def configure_redux_state(conf_obj)
    # expect config in curly braces with state props and pieces of state
    # delineated by semicolon
    puts 'has redux state'

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
    puts 'has dispatch'

    self.top_level_config['has_map_dispatch_to_props'] = true

    options = conf_obj.split('{')[1].gsub('}', '')

    dispatch = options.split(';').map do |item|
      action = item.split('(')
      args = action[1].gsub(')', '').split(',') if action[1]

      { action_name: action[0], args: args}
    end

    self.dispatch = dispatch
  end
end
