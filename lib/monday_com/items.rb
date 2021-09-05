require_relative 'queries'
require_relative 'subitem'

class Item 
  attr_reader :name, :status, :subitems

  def initialize(item)
    @id = item["id"]
    @name = item["name"]
    @status = decode_status(retrieve_status(item))
    @subitems = retrieve_subitems(item)
  end

  def retrieve_status(item)
    status_hash = item["column_values"].select { |item| item["title"] == "Status" }[0]["value"]
    status_hash.nil? ? ":5" : status_hash.match(/index"(:\d)/)[1]
  end

  def retrieve_subitems(item)
    subitems = item["column_values"][0]["value"]
    if !subitems.nil? && subitems != "{}"
      subitems_array = subitems.match(/\{\"linkedPulseIds\"\:\[(.+)\]\}/)[1].split(",")
      subitems_array.map! { |subitem| subitem.match(/\{\"linkedPulseId\":(.+)\}/)[1] }
      subitems_array.map! { |subitem| request(Query.subitems(subitem))["items"][0]["name"] }
    else
      []
    end
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
