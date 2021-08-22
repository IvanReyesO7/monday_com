require_relative 'request'
require_relative 'queries'
# Module that contains the classes to narrow the item search
module Monday
  class Client
    attr_reader :name, :my_items

    def initialize
      @user_id = request(QUERIES[:me])["me"]["id"]
      @name = request(QUERIES[:me])["me"]["name"]
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
