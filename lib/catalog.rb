require 'registry'
require 'support/string_extend'
class Catalog
	class Config
		@@actions = ['list', 'find', 'add', 'quit']
		def self.actions; @@actions; end
	end
	def initialize(path = nil)
	    # locate the restaurant text file at path
		Registry.filepath = path
		if Registry.file_exists?
			puts "Found the file"
			# or create a new file
		elsif Registry.create_file
			puts "Created new file"
			# exit if create fails
		else
			puts "Exiting\n\n"
			exit!
		end
	end

	def launch!
		introduction
		# action loop
		result = nil
		until result == :quit
			action, args = get_action
			result = do_action(action, args)
		end
		conclusion
	end

	def get_action
		action = nil
		# Keep asking for user input until we get a valid action
		until Catalog::Config.actions.include?(action)
			puts "Actions: " + Catalog::Config.actions.join(", ")
			print "> "
			user_response = gets.chomp
			args = user_response.downcase.strip.split(' ')
			action = args.shift
		end
		return action, args
	end

	def do_action(action, args=[])
		case action
		when 'list'
			list(args)
		when 'find'
			keyword = args.shift
      		find(keyword)
		when 'add'
			add
		when 'quit'
			return :quit
		else
			puts "\n I don't understand the command entered\n"
		end
	end

	def list(args=[])
		sort_order = args.shift
	    sort_order = args.shift if sort_order == 'by'
	    sort_order = "name" unless ['name', 'id', 'hall', 'course', 'year'].include?(sort_order)
	    
	    output_action_header("Listing Students")
	    
	    students = Registry.saved_registry
	    students.sort! do |r1, r2|
		    case sort_order
		    when 'name'
		    	r1.name.to_s.downcase <=> r2.name.to_s.downcase
		    when 'id'
		    	r1.id.downcase <=> r2.id.downcase
		    when 'hall'
		    	r1.hall.downcase <=> r2.hall.downcase
		    when 'course'
		    	r1.course.downcase <=> r2.course.downcase
		    when 'year'
		    	r1.year.downcase <=> r2.year.downcase
		    end
	    end
	    output_registry_table(students)
	    puts "Sort using: 'list name' or 'list by hall'\n\n"
  	end

  	def find(keyword="")
    output_action_header("Find a Student")
    if keyword
      students = Registry.saved_registry
      found = students.select do |rest|
        rest.name.downcase.include?(keyword.downcase) || 
        rest.id.downcase.include?(keyword.downcase) || 
        rest.hall.downcase.include?(keyword.downcase) ||
        rest.course.downcase.include?(keyword.downcase) ||
        rest.year.downcase.include?(keyword.downcase)
      end
      output_registry_table(found)
    else
      puts "Find using a key phrase to search the student list."
      puts "Examples: 'find abass', 'find science', 'find hussein'\n\n"
    end
  	end

	def add
		output_action_header("Add a Student")
    	students = Registry.create_using_prompts
		if students.save
			puts "\nStudents Added\n\n"
    	else
      		puts "\nSave Error: Student not added\n\n"
      	end
	end

	def introduction

		puts "\n\n<<<  WELCOME TO THE STUDENT FINDER >>>\n\n"
		puts "This is an interactive app to help you add and find students in a School Registry\n"
	end

	def conclusion
		puts "\n<<< Thank you for using the student finder app  >>>\n\n"		
	end

	private
	
	def output_action_header(text)
	  puts "\n#{text.upcase.center(60)}\n\n"
	end
	
	def output_registry_table(students=[])
	    print " " + "Name".ljust(30)
	    print " " + "Id".ljust(20)
	    print " " + "Hall".ljust(18)
	    print " " + "Course".ljust(10)
	    print " " + "Year".rjust(10) + "\n"
	    puts "-" * 98
	    students.each do |rest|
	      line =  " " << rest.name.to_s.ljust(30)
	      line << " " + rest.id.to_s.ljust(20)
	      line << " " + rest.hall.to_s.ljust(18)
	      line << " " + rest.course.to_s.ljust(16)
	      line << " " + rest.year.to_s.ljust(20)
	      puts line
	    end
	    puts "No listings found" if students.empty?
	    puts "-" * 98
  	end
end