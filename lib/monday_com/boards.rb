require_relative 'items'

class Board
  attr_reader :id, :name
  def initialize(board, user_id)
    @id = board["id"]
    @name = board["name"]
    @items = items(user_id)
  end

  def items(user_id)
    request(Query.items(@id))["boards"][0]["items"]
    all_items = request(Query.items(@id))["boards"][0]["items"]
    my_items = []
    all_items.each do |item|
      assignee = item["column_values"].select{ |value| value["title"] == "Assignee" || value["title"] == "Owner"}[0]["value"]
      my_items << item if assignee && assignee.include?(user_id.to_s)
    end
    my_items.map{ |item| Item.new(item)}
  end
end
