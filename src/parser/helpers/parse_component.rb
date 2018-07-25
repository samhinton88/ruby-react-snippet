class ParseComponent
  # Class which reduces commmand line string into config hash
  # to create a React / Redux component
  attr_reader :raw_command
  attr_accessor :tokens, :types, :top_level_config

  @@component_history = []

  def initialize(command)
    @raw_command = command
    @tokens = []
    @component_name = ''
    @types = []
    @top_level_config = Hash.new(false)
  end

  def call
    tokenise
    parse_name


  end

  def tokenise
    arr_by_whitespace = self.raw_command.split(' ')
    arr_by_whitespace_clean = arr_by_whitespace.map {|item| item.gsub(/\s/, '')}
    self.tokens = arr_by_whitespace_clean
  end

  def parse_name
    # expect first token to be the name of the component in capital case
    perceived_name = tokens.first

    self.component_name = perceived_name
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
      end
    end
  end

  def configure_redux_state(conf_obj)

  end

  def configure_dispatch(conf_obj)

  end
end
