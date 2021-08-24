require_relative 'request'
require_relative 'queries'
require_relative 'boards'
# Module that contains the classes to narrow the item search
module Monday
  class Client
    attr_reader :name, :my_items, :user_id

    def initialize
      @user_id = request(QUERIES[:me])["me"]["id"]
      @name = request(QUERIES[:me])["me"]["name"]
      @boards = boards
    end

    def boards
      all_boards = request(QUERIES[:boards])["boards"]
      my_boards = []
      boards = all_boards.select do |board| 
        board["subscribers"] && board["subscribers"].map { |sub| sub["id"] }.include?(@user_id)
      end
      boards.each do |board|
        my_boards << Board.new(board)
      end
      my_boards
    end

    def items
      @all_items = request(QUERIES[:items])["boards"][0]["items"]
      @my_items = []
      @all_items.each do |item|
        assignee = item["column_values"].select{ |value| value["title"] == "Assignee" }[0]["value"]
        @my_items << item if assignee && assignee.include?(@user_id.to_s)
      end
      @my_items
    end

  end
end

p ivan = Monday::Client.new