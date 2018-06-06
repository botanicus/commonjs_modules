# About

This is experimental [CommonJS modules](http://wiki.commonjs.org/wiki/Modules) implementation in Ruby. The main difference is that in this implementation everything is local, there isn't any messing with the global namespace. It has a lot of advantages include [hot code reloading](http://romeda.org/blog/2010/01/hot-code-loading-in-nodejs.html).

# Usage

From `ruby -Ilib -S pry`:

```ruby
require 'import'

sys = import('examples/1_basic')
# => #<Imports::Export:0x00007f8dae26cd00
#        @__DATA__={
#          :language=>"Ruby", :VERSION_=>"0.0.1",
#          :say_hello=>#<Method #say_hello>},
#        @__FILE__="examples/1_basic.rb">

sys.language
# => "Ruby"

sys.say_hello
# => "Hello World!"
```

## `Kernel#import`

`Kernel#import` is a substitute for:

- `Kernel#require` when used with a path relative to `$LOAD_PATH` or
- `Kernel#require_relative` when used with a path starting with `./` or `../`.

# Discussion

### Usage of modules

This makes use of Ruby modules for namespacing obsolete. Obviously, they still have their use as mixins.

This is a great news. With one global namespace, it's necessary to go full on with the namespacing craziness having all these `LibName::SubModule::Module::ClassName` and dealing either with horrible nesting or with potential for missing module on which we want to definie a class.

Without a global namespace, everything is essentially flat. If we import a `Task`, there's no chance of colision, because we import everything manually and it's crystal clear where every single thing is coming from.

### Why bother if no one else is using it?

Even though all the gems out there are using the global namespace, it doesn't matter, it still a great way to organise your code. It plays well with the traditional approach.

### Usage of refinements

### YARD and RDoc

# TODO

- Rename examples, implicit is only `export ClassName`.
- exports.default = Class.new {}. What .name to set? The file I guess.
- What happens when include is used on a file level? I think this makes refinements obsolete as well UNLESS it's for the core classes such as String or Regexp.
