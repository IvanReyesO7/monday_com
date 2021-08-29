class Query 
  def self.me
    '{ me { is_guest created_at name id}}'
  end

  def self.boards
    '{boards{id name subscribers {id name}}}'
  end

  def self.items(board_id)
    "{ boards (ids: #{board_id}) { items { id name column_values{ id title value } } } }"
  end

  def self.show_item(item)
    "{ items (ids: #{item}) { name column_values{title value}} }"
  end
end

