require_relative 'client'
require_relative 'queries'

module Monday
  class CLI
    def call
      token_login
      begin
        @client = Monday::Client.new
        greetings
        list_items
      rescue "Non authorized user"
      end
    end

    def greetings
      puts "Hello #{@client.name}, these are your pending tasks"
    end

    def list_items
      puts "Your items"
      puts "-" * 50
      @client.items.each do |item|
        puts "#{item.name} ----- #{item.status}"
        if !item.subitems.empty?
          item.subitems.each do |subitem|
            puts "- #{subitem}"
          end
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

