require_relative 'src/interface/index'
require_relative 'src/parser/index'
require_relative 'src/write/index'

config = {
  user_name: 'Sam',
  main_menu: {
    '1' => {
      name:'Create Component', fork: :create_component
    },
    '2' => {
      name: 'Create Types', fork: :create_types
    },
    'Q' => { name: 'Quit', fork: :quit}
  }
}

Interface.new(config, ReactReduxParser, Write).call
