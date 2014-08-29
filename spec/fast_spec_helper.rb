def require_model(name, opts = {})
  opts[:app_path] = LIB_MODEL_PATH if opts.delete(:lib)
  require_resource(name, opts)
end

def require_decorator(name, opts = {})
  opts[:app_path] = DECORATOR_PATH
  require_resource(name, opts)
end

def stub_constants(class_names)
  required_constants(class_names)
end

def required_constants(class_names)
  class_names.each do |class_name|
    class_name, module_name = const_names(class_name)
    define_constant(class_name, Class, root_const(module_name))
  end
end

APP_ROOT       = '../..'
APP_MODEL_PATH = 'app/models'
LIB_MODEL_PATH = 'lib/models'
DECORATOR_PATH = 'app/decorators'

def defaults
  { app_path: APP_MODEL_PATH }
end

def require_resource(name, opts = {})
  opts = defaults.merge(opts)
  require construct_path(name, opts)
end

def construct_path(name, opts = {})
  app_path_to_file = [ opts[:app_path] ]
  app_path_to_file << opts[:sub_dir] if opts[:sub_dir]
  app_path_to_file << name
  app_path_to_file = app_path_to_file.join('/') + '.rb'
  absolute_path(app_path_to_file)
end

def absolute_path(app_path_to_file)
  File.expand_path("#{APP_ROOT}/#{app_path_to_file}", __FILE__)
end

def root_const(module_name)
  module_const = define_constant(module_name, Module) if module_name
  module_const ? module_const : Object
end

def const_names(class_name)
  class_name.split('::').reverse
end

def define_constant(class_name, new_type, const_type = Object)
  const_type.const_set(class_name, new_type.new) unless const_type.const_defined?(class_name)
  const_type
end
