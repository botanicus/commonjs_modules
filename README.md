# About

[![Gem version][GV img]][Gem version]
[![Build status][BS img]][Build status]
[![Coverage status][CS img]][Coverage status]
[![CodeClimate status][CC img]][CodeClimate status]

This is experimental [CommonJS modules](http://wiki.commonjs.org/wiki/Modules) implementation in Ruby. The main difference is that in this implementation everything is local, there isn't any messing with the global namespace. It has a lot of advantages include [hot code reloading](http://romeda.org/blog/2010/01/hot-code-loading-in-nodejs.html).

# Example

### File `lib/task.rb`

```ruby
class Task
  attr_reader :name
  def initialize(name)
    @name
  end
end

# Export single value.
export { Task }
```

### File `lib/runner.rb`

```ruby
Task = import('task')

# Export a variable.
export VERSION: '0.0.1'

# Export a function.
def exports.main(args)
  task = Task.new(args.shift)
  puts "~ #{task.name}"
end
```

### File `bin/main.rb`

```ruby
#!/usr/bin/env ruby -Ilib

require 'import'

runner = import('runner')

# => #<Imports::Export:0x00007f8dae26cd00
#        @__DATA__ = {
#          :VERSION => "0.0.1",
#          :main => #<Method #main>},
#        @__FILE__ = "lib/runner.rb">

# Run the code.
runner.main(ARGV)
```

The syntax is very flexible. Check the [examples](https://github.com/botanicus/commonjs_modules/tree/master/examples) for more.

# API

## `Kernel#import`

`Kernel#import` is a substitute for:

- `Kernel#require` when used with a path relative to `$LOAD_PATH` or
- `Kernel#require_relative` when used with a path starting with `./` or `../`.

## `Imports::Context#exports`

_This object is available as a top-level method, since everything is evaluated against an instance of `Import::Context`_

You can assign anything to `exports`. _Currently the only limitation is that the value cannot be `nil`._

```ruby
exports.VERSION = '0.0.1'

# import('example.rb')
# => #<Imports::Export:0x00007f8dae26cd00
#        @__DATA__ = {
#          :VERSION => "0.0.1",
#        @__FILE__ = "example.rb">
```

If you export key `default`, then only specified value will be exported, rather than an instance of `Imports::Exports` holding multiple values.

```ruby
exports.default = "Only this will be exported."

# import('example.rb')
# => "Only this will be exported."
```

You can also define singleton methods on the `exports` object:

```ruby
def exports.main(*args)
  # TODO: Implement me.
end

# => #<Imports::Export:0x00007f8dae26cd00
#        @__DATA__ = {
#          :main => #<Method #main>},
#        @__FILE__ = "example.rb">
```

This is the only thing that the `export` method doesn't support.

Also, here we are in an `Imports::Exports` instance rather than in `Imports::Context`.

Because of that we use `__ACCESSOR__`s on `Imports::Exports` rather than `accessor`s.

## `Imports::Context#export`

This is a convenience method for assigning things to `exports`

### Exporting default value

```ruby
# Using a block.
export { DefaultValue }

# Using hash.
export default: DefaultValue
```

### Exporting multiple values

```ruby
# Using hash.
export one: ClassOne, two: ClassTwo

# Using names from #name as the key.
# Every exported object has to have the #name method defined.
# That means you have to do it manually for anonymous classes.
class ClassOne; end
class ClassTwo; end

ClassThree = Class.new do
  def self.name
    'ClassThree'
  end
end

export ClassOne, ClassTwo, ClassThree
```

# Discussion

### Usage of modules

This makes use of Ruby modules for namespacing obsolete. Obviously, they still have their use as mixins.

This is a great news. With one global namespace, it's necessary to go full on with the namespacing craziness having all these `LibName::SubModule::Module::ClassName` and dealing either with horrible nesting or with potential for missing module on which we want to definie a class.

Without a global namespace, everything is essentially flat. If we import a `Task`, there's no chance of colision, because we import everything manually and it's crystal clear where every single thing is coming from.

### Why bother if no one else is using it?

Even though all the gems out there are using the global namespace, it doesn't matter, it still a great way to organise your code. It plays well with the traditional approach.

### Usage of refinements

### Static code analysers

The big downside is you can way goodbye YARD, RDoc and many other static code analysers.

_I assume Rubocop, CodeClimate and similar tools will be thrown off as well._

# TODO

- Create missing tests, fix existing ones.
- exports.default = Class.new {}. What .name to set? The file I guess.
- Tag and release version 0.1.

[Gem version]: https://rubygems.org/gems/commonjs_modules
[Build status]: https://travis-ci.org/botanicus/commonjs_modules
[Coverage status]: https://coveralls.io/github/botanicus/commonjs_modules
[CodeClimate status]: https://codeclimate.com/github/botanicus/commonjs_modules/maintainability

[GV img]: https://badge.fury.io/rb/commonjs_modules.svg
[BS img]: https://travis-ci.org/botanicus/commonjs_modules.svg?branch=master
[CS img]: https://img.shields.io/coveralls/botanicus/commonjs_modules.svg
[CC img]: https://api.codeclimate.com/v1/badges/a99a88d28ad37a79dbf6/maintainability
