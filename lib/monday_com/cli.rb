require_relative 'client'

module Monday
  class CLI
    def call
      @client = Monday::Client.new
      greetings
      list_items
    end

    def greetings
      puts "Hello #{@client.name}, these are your pending tasks"
    end

    def list_items
      puts "\nYour Items:"
      puts "--" * 25
      @items = @client.items
      @items.each do |item|
        puts item["name"]
      end
    end
  end
end

this = Monday::CLI.new
this.call