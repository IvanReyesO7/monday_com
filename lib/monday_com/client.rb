require_relative 'request'
require_relative 'queries'
require_relative 'boards'
# Module that contains the classes to narrow the item search
module Monday
  class Client
    attr_reader :name, :my_items, :user_id

    def initialize
      @user_id = request(Query.me)["me"]["id"]
      @name = request(Query.me)["me"]["name"]
      @boards = boards
    end

    def boards
      all_boards = request(Query.boards)["boards"]
      boards = all_boards.select do |board| 
        board["subscribers"] && board["subscribers"].map { |sub| sub["id"] }.include?(@user_id)
      end
      boards.map { |board| Board.new(board, @user_id) }
    end

  end
end
