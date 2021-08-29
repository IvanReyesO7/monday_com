require_relative 'queries'

class Item 
  def initialize(item)
    @id = item["id"]
    @name = item["name"]
    @status = decode_status(status(item))
  end

  def status(item)
    status_hash = item["column_values"].select { |item| item["title"] == "Status" }[0]["value"]
    status_hash.nil? ? ":5" : status_hash.match(/index"(:\d)/)[1]
  end

  def decode_status(status_code)
    stauts_table = {
      ":0": "Working on it",
      ":1": "Done",
      ":2": "Stuck",
      ":3": "Live in Production",
      ":4": "Await Response",
      ":5": "Not Started",
      ":6": "Pull Request",
      ":7": "Ready for Code Review",
      ":9": "On Hold - Client request",
      ":10": "Testing"
    }
    stauts_table[status_code.to_sym]
  end
end
