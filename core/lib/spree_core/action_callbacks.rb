module Spree
  class ActionCallbacks
    attr_reader :before_methods
    attr_reader :after_methods
    
    def initialize
      @before_methods = []
      @after_methods = []
    end
    
    def before(method)
      @before_methods << method
    end
    
    def after(method)
      @after_methods << method
    end
  end
end

CanCan::ControllerResource.class_eval do
  def collection_instance=(instance)
    @controller.instance_variable_set("@collection", instance)
    @controller.instance_variable_set("@#{instance_name.to_s.pluralize}", instance)
  end
  
  def resource_instance=(instance)
    @controller.instance_variable_set("@object", instance)
    @controller.instance_variable_set("@#{instance_name}", instance)
  end
end
