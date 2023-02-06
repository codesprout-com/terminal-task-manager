require 'sqlite3'

require_relative './app_constants'

class TaskManager
  ADD = "add"
  REMOVE = "remove"
  LIST = "list"

  VALID_COMMANDS = [ ADD, REMOVE, LIST ]

  def initialize(command:)
    @command = command
    @database = SQLite3::Database.new(DATABASE_NAME)
  end

  def run
    case @command
    when ADD
      puts "What task would you like to add?"
      print "> "
      name = STDIN.gets.chomp.strip

      if name.size > 200
        STDERR.puts "Task names cannot be greater than 200 characters!"
        exit(1)
      end

      puts "What priority is this task?"
      print "> "
      priority = STDIN.gets.chomp.strip.to_i

      add_to_database(name: name, priority: priority)
    when REMOVE
      puts "What task do you want to remove (provide database ID)"
      print "> "
      id = STDIN.gets.chomp.strip

      remove_from_database(id: id)
    when LIST
      list_from_database
    else
      puts "unrecognized command"
    end
  end

  private

  def add_to_database(name:, priority:)
    @database.execute(
      "INSERT INTO tasks (name, priority, date) VALUES (?, ?, ?)",
      [ name, priority, Time.now.strftime('%F') ]
    )
  end

  def remove_from_database(id:)
    @database.execute("DELETE FROM tasks where id = ?", id)
  end

  def list_from_database
    @database.execute("SELECT * FROM tasks ORDER BY priority ASC") do |row|
      id       = row[0]
      priority = row[1]
      name     = row[2]
      date     = row[3]

      puts "TASK: #{name}"
      puts "  -> added on #{date}"
      puts "  -> priority #{priority}"
      puts "  -> id #{id}"
      puts "-------------"
    end
  end

end