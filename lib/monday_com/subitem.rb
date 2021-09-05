class SubItem
  def initialize(id)
    @id = id
    @name = request(Query.subitems(id))
  end
end