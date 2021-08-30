require_relative 'client'

module Monday
  class CLI
    def call
      authentication
      @client = Monday::Client.new
      greetings
      list_items
    end

    def greetings
      puts "Hello #{@client.name}, these are your pending tasks"
    end

    def list_items
      @client.boards.each do |board|
        puts board.name
        puts "\nYour Items:"
        puts "--" * 25
        items = board.items
        items.each do |item|
          puts item.name
        end
      end
    end

    private

    def authentication
      if ENV["MONDAY_COM_TOKEN"].nil?
        puts "Monday.com token"
        print ">"
        token = gets.chomp
        ENV["MONDAY_COM_TOKEN"] = "#{token}"
      end
    end
  end
end
