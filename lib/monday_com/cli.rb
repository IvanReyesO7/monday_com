require_relative 'client'
require_relative 'queries'
require 'terminal-table'

module Monday
  class CLI
    def call
      token_login
      begin
        @client = Monday::Client.new
      rescue "Non authorized user"
      end
      greetings
      list_items_table
    end

    def greetings
      puts "Hello #{@client.name}, these are your tasks"
    end

    def list_items
      puts "Your items"
      puts "-" * 50
      @client.items.sort_by{ |item| item.date }.reverse.each do |item|
        puts "#{item.name} --- #{item.date.strftime('%b %d')} --- #{item.status}"
        if !item.subitems.empty?
          item.subitems.each do |subitem|
            puts "- #{subitem}"
          end
        end
      end
    end

    def list_items_table
      rows = []
      @client.items.sort_by{ |item| item.date }.reverse.each do |item|
        rows << [item.name, item.date.strftime('%b %d'), item.status]
      end
      puts table = Terminal::Table.new(rows: rows)
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

