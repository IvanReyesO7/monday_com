module Monday
  class Board
    attr_reader :id, :name
    def initialize(board)
      @id = board["id"]
      @name = board["name"]
    end

    def item
    end
  end
end