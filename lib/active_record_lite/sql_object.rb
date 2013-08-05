require_relative './associatable'
require_relative './db_connection'
require_relative './mass_object'
require_relative './searchable'
require "active_support/inflector"

class SQLObject < MassObject
  extend Searchable
  
  def self.set_table_name(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.name.underscore
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT *
      FROM #{self.table_name}
    SQL
    
    parse_all(results)
  end

  def self.find(id)    
    results = DBConnection.execute(<<-SQL)
      SELECT *
      FROM #{self.table_name}
      WHERE
      id = #{id}
    SQL
    
    parse_all(results)
  end

  def save
    if @id.nil?
      create
    else
      update
    end
  end
  
  private
  def attribute_values
    self.class.attributes.map{ |attribute| self.send(attribute)}
  end
  
  def self.parse_all(db_array)
    objects = []
    db_array.each do |options|
     objects << self.new(options)
    end
    objects
  end
  
  def create
    attribute_names = self.class.attributes.join(", ")
    question_marks = (['?']* self.class.attributes.count).join(", ")
    
    results = DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO #{self.class.table_name} (#{attribute_names}) 
      VALUES (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    attributes_str = self.class.attributes.join(" = ?, ")
    attributes_str.concat(" = ?")
    
    results = DBConnection.execute(<<-SQL, *attribute_values)
    UPDATE #{self.class.table_name}
    SET #{attributes_str}
    WHERE id = #{id}
    SQL
  end
end
