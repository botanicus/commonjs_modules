# About

This is experimental [CommonJS modules](http://wiki.commonjs.org/wiki/Modules) implementation in Ruby. The main difference is that in this implementation everything is local, there isn't any messing with the global namespace. It has a lot of advantages include [hot code reloading](http://romeda.org/blog/2010/01/hot-code-loading-in-nodejs.html).

# Usage

We are working with the `example.rb`:

```ruby
# It works with $LOAD_PATH exactly as Kernel#require does.
$: << File.expand_path('.')

require 'import'

sys = import('example')
# => #<CommonJS::Proxy:0x00007fe73bac01f0 @data={
#       :language=>"Ruby", :VERSION_=>"0.0.1",
#       :say_hello=>#<Method: #<CommonJS::Proxy:0x00007fe73bac01f0 ...>.say_hello>,
#       :Task=>Task}>

sys.language
# => "Ruby"

sys.say_hello
# => "Hello World!"
```

# Discussion

This makes use of Ruby modules for namespacing obsolete. Obviously, they still have their use as mixins.

# TODO

- Cache modules.
- An example with refinements.
- What happens when include is used on a file level? I think this makes refinements obsolete as well UNLESS it's for the core classes such as String or Regexp.
