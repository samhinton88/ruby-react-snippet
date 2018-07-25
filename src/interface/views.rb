class View

  def greet(user_name)
    puts "Hello #{user_name}!"
  end

  def get_command
    puts "Please enter a command:"
    command = gets.chomp
  end

  def show_menu(menu)
    write_menu(menu)
  end

  def ask_input
    print '> '
    gets.chomp
  end

  def cache_summary(parser_instance)
    puts "#{parser_instance.parsed_objects.size.to_s} objects in cache"
  end

  private
  def write_menu(menu)
    menu.keys.sort.each {|k| puts "(#{k}) #{menu[k][:name]}"}
  end
end
