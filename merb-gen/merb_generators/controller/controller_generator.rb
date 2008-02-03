class ControllerGenerator < Merb::GeneratorBase
  
  attr_reader :controller_class_name, 
              :controller_file_name, 
              :controller_base_path,
              :controller_modules
  
  def initialize(args, runtime_args = {})
    @base =             File.dirname(__FILE__)
    super
    name = args.shift
    @controller_file_name   = name.snake_case.gsub("::", "/")
    
    # Need to setup the directories
    unless @controller_file_name == File.basename(@controller_file_name)
      @controller_base_path   = controller_file_name.split("/")[0..-2].join("/") 
    end
    
    @controller_modules     = @controller_file_name.to_const_string.split("::")[0..-2]
    @controller_class_name  = @controller_file_name.to_const_string.split("::").last
  end
  
  def manifest
    record do |m|
      @m = m
      
      # Create the controller directory
      m.directory File.join("app/controllers", controller_base_path) if controller_base_path
      
      # Create the helpers directory
      m.directory File.join("app/helpers", controller_base_path) if controller_base_path
      
      @assigns =  {
                    :controller_modules    => controller_modules,
                    :controller_class_name => controller_class_name,
                    :controller_file_name  => controller_file_name,
                    :controller_base_path  => controller_base_path 
                  }
      
      copy_dirs
      copy_files
      
      m.dependency "merb_controller_test", [@controller_class_name], @assigns
    end
  end
end