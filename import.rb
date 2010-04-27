# encoding: utf-8

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
        @data[method.to_s[0..-2].to_sym] = args.first
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
