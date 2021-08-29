require_relative 'queries'

class Item 
  def initialize(item)
    @id = item["id"]
    @name = item["name"]
    @status = status(item)
  end

  def status(item)
    item["column_values"].select { |item| item["title"] == "Status"}
  end

end