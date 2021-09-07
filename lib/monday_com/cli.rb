require_relative 'client'
require_relative 'queries'
require 'terminal-table'
require 'colorized_string'

module Monday
  class CLI
    def call(arg=[])
      case arg
      when []
        token_login
        begin
          @client = Monday::Client.new
        rescue "Non authorized user"
        end
        greetings
        list_items_table
      when ["--subitems"]
        token_login
        begin
          @client = Monday::Client.new
        rescue "Non authorized user"
        end
        greetings
        list_items_table_subitems
      when ["--pending"]
        token_login
        begin
          @client = Monday::Client.new
        rescue "Non authorized user"
        end
        greetings
        list_items_table_pending
      when ["--version"]
        puts "1.0.0"
      when ["--help"]
        puts "monday_com is a gem desgined by Ivan to visualize his monday.com tasks without leaving the terminal" 
        puts "commands"
        puts "--subitems : Prints all the tasks including it's subitems"
        puts "--version : Shows the gem version"
        puts "--pending : Prints only the pending tasks"
      else
        puts "Could not find the command \"#{arg[0]}\""
      end
    end

    def greetings
      puts "Authenticated as #{@client.name}"
    end

    def list_items_table
      rows = []
      @client.items.sort_by{ |item| item.date }.reverse.each do |item|
        rows << [item.name, item.date.strftime('%b %d'), colorize(item.status)]
      end
      pending = @client.items.count{ |item| item.status != 'Done' }
      puts table = Terminal::Table.new(title: "You have (#{pending}) pending taks", headings: ['Tasks', 'Asignation date', 'Status'],rows: rows)
    end

    def list_items_table_subitems
      rows = []
      @client.items.sort_by{ |item| item.date }.reverse.each do |item|
        rows << [item.name, item.date.strftime('%b %d'), colorize(item.status)]
        if !item.subitems.empty?
          case item.subitems.count
          when 1
            item.subitems.each do |subitem|
              rows << ["└- #{ColorizedString[subitem].colorize(:light_black)}", "-", ""]
            end
          else
            item.subitems[0...-1].each do |subitem|
              rows << ["├- #{ColorizedString[subitem].colorize(:light_black)}", "-", ""]
            end
          rows << ["└- #{ColorizedString[item.subitems.last].colorize(:light_black)}", "-", ""]
          end
        end
      end
      pending = @client.items.count{ |item| item.status != 'Done' }
      puts table = Terminal::Table.new(title: "You have (#{pending}) pending taks", headings: ['Tasks', 'Asignation date', 'Status'],rows: rows)
    end

    def list_items_table_pending
      rows = []
      @client.items.select{|item| item.status != 'Done'}.sort_by{ |item| item.date }.reverse.each do |item|
        rows << [item.name, item.date.strftime('%b %d'), colorize(item.status)]
      end
      pending = @client.items.count{ |item| item.status != 'Done' }
      puts table = Terminal::Table.new(title: "You have (#{pending}) pending taks", headings: ['Tasks', 'Asignation date', 'Status'],rows: rows)
    end

    private

    def token_login
      if ENV["MONDAY_COM_TOKEN"].nil?
        puts "Monday.com token"
        print ">"
        token = STDIN.gets.chomp
        ENV["MONDAY_COM_TOKEN"] = "#{token}"
      end
    end

    def colorize(string)
      ColorizedString[string].colorize(STATUS_COLORS[string.to_sym])
    end

    STATUS_COLORS = {
      "Working on it": :yellow,
      "Done": :green,
      "Stuck": :red,
      "Live in Production": :light_blue,
      "Await Response": :light_cyan,
      "Not Started": :default,
      "Pull Request": :magenta,
      "Ready for Code Review": :cyan,
      "On Hold - Client request": :yellow,
      "Testing": :white
    }
  end
end

