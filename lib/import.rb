module Imports
  class DSL
    attr_reader :exports
    def initialize
      @exports = Context.new
    end
  end

  class Context #< BasicObject
    attr_reader :data
    def initialize
      @data = Hash.new
    end

    # def self.const_missing(name)
    #   ::Object.const_get(name)
    # end

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
    # import('./test') and import('../test') behave like require_relative.
    if path.start_with?('.')
      caller_file = caller_locations.first.absolute_path

      unless caller_file
        raise "Error when importing #{path}: caller[0] is #{caller[0]}"
      end

      base_dir = caller_file.split('/')[0..-2].join('/')
      path = File.expand_path("#{base_dir}/#{path}")
      require 'pry'; binding.pry ###
    end

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
    object = Imports::DSL.new
    object.instance_eval(code)

    if object.exports.data.keys == [:default]
      return object
    elsif object.exports.data.keys.include?(:default)
      raise "Default export detected, but it wasn't the only export: #{export.data.keys.inspect}"
    else
      return object.exports
    end
  end
end
