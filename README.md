# About

This is experimental [CommonJS modules](http://wiki.commonjs.org/wiki/Modules) implementation in Ruby. The main difference is that in this implementation everything is local, there isn't any messing with the global namespace. It has a lot of advantages include [hot code reloading](http://romeda.org/blog/2010/01/hot-code-loading-in-nodejs.html).

# Usage

We are working with the `example.rb`:

    # It works with $LOAD_PATH exactly as Kernel#require does
    $: << File.expand_path(".")

    require "import"

    sys = import("example")
    # => #<CommonJS::Proxy:0x00000101170398 @data={:language => "Ruby", :VERSION_ => "0.0.1"}>

    sys.language
    # => "Ruby"
    
    sys.say_hello
    # => "Hello World!"

# Problems

* Construction `def exports.a_method` doesn't add the method into `CommonJS::Proxy#data`, so we can't iterate over all the methods in given module.
