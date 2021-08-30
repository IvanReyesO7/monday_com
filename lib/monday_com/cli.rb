require_relative 'client'
require_relative 'queries'

module Monday
  class CLI
    def call
      token_login
      begin
        @client = Monday::Client.new
        list_items
      rescue
        print "Non authorized user"
      end
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

    def token_login
      if ENV["MONDAY_COM_TOKEN"].nil?
        puts "Monday.com token"
        print ">"
        token = gets.chomp
        ENV["MONDAY_COM_TOKEN"] = "#{token}"
      end
    end
  end
end

