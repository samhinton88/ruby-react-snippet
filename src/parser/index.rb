require_relative 'helpers/parse_component'

class ReactReduxParser
  @@parsed_objects = []

  def initialize


  end

  def parse_component_from(command)
    component = ParseComponent.new(command).call
    @@parsed_objects.push(component)
    puts 'parsed_objects'
    puts @@parsed_objects
  end

  def self.parsed_objects
    @@parsed_objects
  end
end
