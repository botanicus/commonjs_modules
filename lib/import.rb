module Imports
  module DSL
    private

    # export default: TaskList
    # export Task: Task, TL: TaskList
    def export(*args)
      if args.length == 1 && args.first.is_a?(Hash)
        hash = args.first
        if hash.keys.include?(:default) && hash.keys.length == 1
          exports.default = hash[:default]
        elsif hash.keys.include?(:default) && hash.keys.length > 1
          raise "Default export detected, but it wasn't the only export: #{hash.keys.inspect}"
        else
          hash.keys.each do |key|
            export.send(:"#{key}=", hash[key])
          end
        end
      else
        args.each do |object|
          exports.data[object.name] = object
        rescue NoMethodError
          raise ArgumentError.new("Every object has to respond to #name. Export the module manually using exports.name = object if the object doesn't respond to #name.")
        end
      end
    end
  end

  class Context
    include DSL

    attr_reader :exports
    def initialize
      @exports = Export.new
    end
  end

  class Export
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
    object = Imports::Context.new
    object.instance_eval(code)

    keys = object.exports.data.keys
    if keys.include?(:default) && keys.length == 1
      return object.exports.default
    elsif keys.include?(:default) && keys.length > 1
      raise "Default export detected, but it wasn't the only export: #{keys.inspect}"
    else
      return object.exports
    end
  end
end
