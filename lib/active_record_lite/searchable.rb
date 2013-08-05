require_relative './db_connection'

module Searchable
  def where(params)
    where_keys = params.keys.map{|k, v| "#{k} = ?"}.join(" AND ")
    
    results = DBConnection.execute(<<-SQL, *params.values )
      SELECT *
      FROM #{self.table_name}
      WHERE #{where_keys}
    SQL
    
    self.parse_all(results)
  end 
  
end