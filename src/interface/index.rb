require_relative 'views'

class Interface
  attr_reader :view, :config
  attr_writer :mode, :running
  def initialize(config, parser, writer)
    @config     = config
    @view       = View.new
    @mode       = ''
    @running    = true
    @parser     = parser.new
    @writer     = writer.new
  end

  def call
    self.greet_user
    view.show_menu(config[:main_menu])

    command = config[:main_menu][view.get_command][:fork]

    self.mode = command
    self.send command

  end

  def greet_user
    view.greet(config[:user_name])
  end

  def quit
    puts "Quiting program, have a nice day"
    self.running = false
  end

  def create_component
    command = view.ask_input

    parser.create_component(command)
  end
end
