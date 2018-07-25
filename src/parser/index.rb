require_relative 'helpers/parse_component'

class ReactReduxParser
  @@parsed_objects = []

  def initialize


  end

  def parse_component_from(command)
    dep_map = {
      redux: { npm_name: 'react-redux', destructure: ['connect'], },
      react: { npm_name: 'react', destructure: ['Component'], import: 'React',}
    }
    component = ParseComponent.new(command, dep_map).call
    @@parsed_objects.push(component)
    puts 'parsed_objects'
    puts @@parsed_objects
  end

  def self.parsed_objects
    @@parsed_objects
  end
end
