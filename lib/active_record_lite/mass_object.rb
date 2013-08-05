class MassObject
  def self.set_attrs(*attributes)  
    self.new_attr_accessor(*attributes)
    #attr_accessor(*attributes)
    
    # attributes.each do |attribute|
#       attr_accessor attribute.to_sym
#     end
    
    @attributes = attributes
  end

  def self.attributes
    @attributes
  end

  def self.parse_all(results)
  end

  def initialize(params = {})
    params.each do |attribute, value|
      attribute = attribute.to_sym
      raise "mass assignment to unregistered attribute #{attribute}" unless self.class.attributes.include?(attribute)
      self.send("#{attribute}=", value)
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