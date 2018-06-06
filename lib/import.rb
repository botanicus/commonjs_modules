module CommonJS
  class RequiredModule
    attr_reader :exports
    def initialize
      @exports = Proxy.new
    end
  end

  class Proxy
    attr_reader :data
    def initialize
      @data = Hash.new
    end

    # register methods
    def singleton_method_added(method)
      @data[method] = self.method(method)
    end

    # register variables and constants
    def method_missing(method, *args, &block)
      if method.to_s.match(/=$/) && args.length == 1 && block.nil?
        object_name = method.to_s[0..-2].to_sym
        object = args.first

        @data[object_name] = object

        if object.is_a?(Class) && object.name.nil?
          object.define_singleton_method(:name) { object_name.to_s }
        end
      elsif @data[method]
        @data[method]
      else
        super(method, *args, &block)
      end
    end
  end
end

module Kernel
  def import(path)
    if File.file?(path)
      fullpath = path
    elsif File.file?("#{path}.rb")
      fullpath = "#{path}.rb"
    else
      $:.each do |directory|
        choices  = [File.join(directory, path), File.join(directory, "#{path}.rb")]
        fullpath = choices.find { |choice| File.file?(choice) }
      end
      if ! defined?(fullpath) || fullpath.nil?
        raise LoadError, "no such file to import -- #{path}"
      end
    end
    code   = File.read(fullpath)
    object = CommonJS::RequiredModule.new
    object.instance_eval(code)
    return object.exports
  end
end
