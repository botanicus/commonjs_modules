# frozen_string_literal: true

module Imports
  def self.register
    @register ||= Hash.new
  end

  def self.resolve_against_load_path(path)
    $LOAD_PATH.uniq.each do |directory|
      choices  = [File.join(directory, path), File.join(directory, "#{path}.rb")]
      fullpath = choices.find { |choice| File.file?(choice) }
      return fullpath if fullpath
    end

    nil
  end

  def self.resolve_path(path)
    # import('./test') and import('../test') behave like require_relative.
    if path.start_with?('.')
      # Block in <main> is to make import work within rackup. Not sure whether it doesn't break something else though.
      location = caller_locations.find { |location| location.label == "<top (required)>" || location.label == "block in <main>" }

      raise "Error when importing #{path}" unless location

      base_dir = location.absolute_path.split('/')[0..-2].join('/')
      path = File.expand_path("#{base_dir}/#{path}")
    end

    if File.file?(path)
      fullpath = path
    elsif File.file?("#{path}.rb")
      fullpath = "#{path}.rb"
    else
      unless fullpath = self.resolve_against_load_path(path)
        raise LoadError, "no such file to import -- #{path}"
      end
    end

    File.expand_path(fullpath)
  end

  module DSL
    private

    # export default: TaskList
    # export Task: Task, TL: TaskList
    # export { MyClass } # export as default
    def export(*args, &block)
      if block && args.empty?
        # Lazy-loaded and cached.
        # export { Task }
        exports.define_singleton_method(:default) { @default ||= yield }
      elsif block && args.length == 1
        # Lazy-loaded and cached.
        # export(:logger) { Logger.new }
        exports.define_singleton_method(args.first) do
          if self.instance_variable_get(:"@#{args.first}").nil?
            self.instance_variable_set(:"@#{args.first}", yield)
          end

          self.instance_variable_get(:"@#{args.first}")
        end
      elsif block && args.length > 1
        raise "When used with a block, one or no argument is expected."
      elsif args.length == 1 && args.first.is_a?(Hash)
        hash = args.first
        if hash.key?(:default) && hash.keys.length == 1
          # export default: MyClass
          exports.default = hash[:default]
        elsif hash.key?(:default) && hash.keys.length > 1
          # export default: MyClass, something_else: MyOtherClass
          raise "Default export detected, but it wasn't the only export: #{hash.keys.inspect}"
        else
          # export Task: Task, TL: TaskList
          hash.keys.each do |key|
            exports.send(:"#{key}=", hash[key])
          end
        end
      else
        # export MyClass
        args.each do |object|
          raise TypeError, "Exported object cannot be nil!" if object.nil?

          # Remove the anonymous namespace, i. e. the first part of "#<Class:0x00005643e873a528>::Subscriptions".
          name = object.name.split('::')[1..-1].join('::').to_sym

          # At least for classes and modules:
          # object.define_singleton_method(:name) { name }
          object.define_singleton_method(:inspect) { name }

          exports._DATA_[name] = object
        rescue NoMethodError
          raise ArgumentError, "Every object has to respond to #name. Export the module manually using exports.name = object if the object doesn't respond to #name."
        end
      end
    end
  end

  class Context < BasicObject
    include DSL

    attr_reader :exports
    def initialize(path)
      @exports = Export.new(path)
    end

    def self.const_missing(name)
      ::Object.const_get(name)
    end

    def name
      binding.irb
    end

    def inspect
      binding.irb
    end

    KERNEL_METHODS_DELEGATED = [:import, :require, :raise, :puts, :p].freeze

    def method_missing(name, *args, &block)
      super unless KERNEL_METHODS_DELEGATED.include? name
      ::Kernel.send(name, *args, &block)
    end

    def respond_to_missing?(name, include_private = false)
      KERNEL_METHODS_DELEGATED.include?(name) || super
    end
  end

  # Only def exports.something; end is evaluated in the context of Export.
  # Hence these are not recommented for bigger things, but it works fine
  # for a collection of few methods that don't need a separate class.
  class Export
    attr_reader :_FILE_, :_DATA_
    def initialize(path)
      @_FILE_, @_DATA_ = path, ::Hash.new
    end

    # Register methods.
    def singleton_method_added(method)
      @_DATA_[method] = self.method(method)

      @_DATA_[method].define_singleton_method(:inspect) do
        "#<#{self.class} ##{method}>"
      end
    end

    # Register variables and constants.
    def method_missing(method, *args, &block)
      if method.to_s.match(/=$/) && args.length == 1 && block.nil?
        object_name = method.to_s[0..-2].to_sym
        object = args.first

        @_DATA_[object_name] = object

        if object.is_a?(Class) && object.name.nil?
          object.define_singleton_method(:name) { object_name.to_s }
          object.define_singleton_method(:inspect) { object_name.to_s }
        end
      elsif @_DATA_.key?(method)
        @_DATA_[method]
      else
        super(method, *args, &block)
      end
    end

    def respond_to_missing?(method, include_private = false)
      (method.to_s.match(/=$/) && args.length == 1 && block.nil?) || @_DATA_.key?(method)
    end

    # Convenience methods.
    # TODO: Must fail if key not present.
    def grab(*args)
      args.map { |arg| self.send(arg) }
    end
  end
end

module Kernel
  def import(path)
    absolute_path = Imports.resolve_path(path)

    object = Imports.register[absolute_path] ||= begin
      code   = File.read(absolute_path)
      object = Imports::Context.new(path)
      object.instance_eval(code, path)
      object
    end

    keys = object.exports._DATA_.keys
    if keys.include?(:default) && keys.length == 1
      return object.exports.default
    elsif keys.include?(:default) && keys.length > 1
      raise "Default export detected, but it wasn't the only export: #{keys.inspect}"
    else
      return object.exports
    end
  end
end
