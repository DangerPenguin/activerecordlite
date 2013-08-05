class MassObject
  def self.set_attrs(*attributes)  
    self.new_attr_accessor(*attributes)
    
    @attributes = []
    attributes.each do |attribute|
      @attributes << attribute
    end 
  end

  def self.attributes
    @attributes
  end

  def self.parse_all(results)
  end

  def initialize(params = {})
     
    params.each do |attribute, value|
      self.send("#{attribute}=", value)
      raise "mass assignment to unregistered attribute #{attribute}" unless self.class.attributes.include?(attribute)
    end
    
  end
  
  def self.new_attr_accessor(*variables)   
    variables.each do |variable|
      
      define_method("#{variable}") do
        instance_variable_get("@#{variable}")
      end     
      
      define_method("#{variable}=") do |argument| 
        instance_variable_set("@#{variable}", argument)
      end
    end  
  end
  
end