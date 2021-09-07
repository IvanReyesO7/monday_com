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
        if !item.subitems.empty?
          case item.subitems.count
          when 1
            item.subitems.each do |subitem|
              rows << ["└- #{subitem}", "-", ""]
            end
          else
            item.subitems[0..-1].each do |subitem|
              rows << ["├- #{subitem}", "-", ""]
            end
          rows << ["└- #{item.subitems.last}", "-", ""]
          end
        end
      end
      pending = @client.items.count{ |item| item.status != 'Done' }
      puts table = Terminal::Table.new(title: "You have (#{pending}) pending taks", headings: ['Tasks', 'Asignation date', 'Status'],rows: rows)
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

