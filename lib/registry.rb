require 'support/number_helper'

class Registry
	include NumberHelper

	@@filepath = nil
	def self.filepath=(path=nil)
		@@filepath = File.join(APP_ROOT, path)
	end

	attr_accessor :name, :id, :hall, :course, :year

	def self.file_exists?
		# class should know if the student file exists
		if @@filepath && File.exists?(@@filepath)
			return true
		else
			return false
		end	
	end

	def self.file_usable?
		return false unless @@filepath
		return false unless File.exists?(@@filepath)
		return false unless File.readable?(@@filepath)
		return false unless File.writable?(@@filepath)
		return true
	end

	def self.create_file
		# class should be able to create file if it doesnt already exist
		File.open(@@filepath, 'w') unless file_exists?
		return file_usable?
	end

	def self.saved_registry
		# read the registry file
		# return instances of the registry file
		# We have to ask ourselves, do we want a fresh copy each 
    	# time or do we want to store the results in a variable?
    	students = []
    	if file_usable?
    		file = File.new(@@filepath, 'r')
    		file.each_line do |line|
    			students << Registry.new.import_line(line.chomp)
    		end
    		file.close
    	end
    	return students
	end


	def self.create_using_prompts
	 args = {}
	 print "Student Name: "
		args[:name] = gets.chomp.strip

		print "Student ID : "
		args[:id] = gets.chomp.strip

		print "Student's Resident Hall: "
		args[:hall] = gets.chomp.strip

		print "Student Course: "
		args[:course] = gets.chomp.strip

		print "Student Year: "
		args[:year] = gets.chomp.strip
		return self.new(args)
	end

	def initialize(args={})
		@name   = args[:name]   || ""
		@id     = args[:id]     || ""
		@hall   = args[:hall]   || ""
		@course = args[:course] || ""
		@year   = args[:year]   || ""
	end

	def import_line(line)
		line_array = line.split("\t")
		@name, @id, @hall, @course, @year = line_array
		return self
	end

	def save
		return false unless Registry.file_usable?
		File.open(@@filepath, 'a') do |file|
		 file.puts "#{[@name, @id, @hall, @course, @year].join("\t")}\n"
		end
		return true
	end
end