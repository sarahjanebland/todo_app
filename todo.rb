class Task
  attr_accessor :description, :status
  
  def initialize(description, status="active") #string vs symbol?
    @description = description || "Initialized with no text"
    @status = status || "Initialized with no status"
  end
end



class FileParser
  attr_accessor :list 

  def initialize
    parse
    @task_list = [] #BROOKS MERGE
  end 

  def parse
    @list = List.new
    raw_data = File.open('todo.txt').readlines
    description_data, status_data = [], []
    raw_data.map { |x| description_data   <<    x[/[a-zA-Z].*[|]/].chomp(' |') }
    raw_data.map { |x| status_data    <<    x[/[|].*/].delete('|') }
    raw_data.each_with_index { |e,i| @list.tasks << Task.new(description_data[i], status_data[i]) }
  end

  def format #BROOKS MERGE
    @list.tasks.each_with_index do |task, i| 
      @task_list << "#{i}. #{task.description} |#{task.status}" 
    end
  end

  def write #BROOKS MERGE
    format
    File.open("todo.txt", "wb") do |file| #TD change output.txt to todo.txt
      file.write @task_list.join("\n")
    end
  end

end 


class UserConcierge
  attr_reader :command, :task_or_id 

  def initialize
  end 
  
  def get_input
    @command = ARGV[0]
    @task_or_id = ARGV[1]
  end 

  def self.delete_message(deleted_task)
    puts "'#{deleted_task.description}' was succesfully deleted."
  end 

  def self.add_message(task)
    puts "'#{task}' was successfully added to your list."
  end

  def self.completed_message(task)
    puts "'#{task.description}' has been marked complete."
  end

  def self.beautiful_list_display(task, id)
     puts "#{id}. #{task.description}  | #{task.status}"
  end 

end 


class Controller
  attr_accessor :tasks
  
  def initialize(tasks)
    @tasks = tasks 
  end 

  def interpret(command, task_or_id)
    case command
      when "add"
        add(task_or_id)
      when "delete"
        delete!(task_or_id)
      when "complete"
        complete(task_or_id)
      when "list"
        display_list
    end
  end 

  def add(task)
    @tasks << Task.new()
    UserConcierge.add_message(task)
  end 

  def delete!(id)
    deleted_task = @tasks.delete_at(id.to_i) 
    UserConcierge.delete_message(deleted_task)
  end 

  def complete(id)
    @tasks[id.to_i].status = "complete"
    UserConcierge.completed_message(@tasks[id.to_i])
  end 

  def display_list
    @tasks.each_with_index do |task, index|
      UserConcierge.beautiful_list_display(task, index)
    end
  end
end  


# Driver Code
require 'pp'

#Setup
concierge   = UserConcierge.new
parser      = FileParser.new
controller  = Controller.new(parser.list.tasks) ## will this work? 


#Take action 
concierge.get_input 
controller.interpret(concierge.command, concierge.task_or_id)
parser.write 

#Display action, only for testing. 
#PP.pp controller.tasks 












