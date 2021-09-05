require_relative 'request'
require_relative 'queries'
require_relative 'items'
# Module that contains the classes to narrow the item search
module Monday
  class Client
    attr_reader :name, :my_items, :user_id

    def initialize
      @user_id = request(Query.me)["me"]["id"]
      @name = request(Query.me)["me"]["name"]
      @items = items
    end

    def items
      all_items = request(Query.items)["boards"][0]["items"]
      my_items = []
      all_items.each do |item|
        assignee = item["column_values"].select { |value| value["title"] == "Assignee" || value["title"] == "Owner" } [0]["value"]
        my_items << item if assignee && assignee.include?(@user_id.to_s)
      end
      my_items.map { |item| Item.new(item) }
    end
  end
end
