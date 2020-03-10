Gem::Specification.new do |s|
  s.name        = 'commonjs_modules'
  s.version     = '0.1.0'
  s.authors     = ['Jakub Šťastný']
  s.homepage    = 'https://github.com/jakub-stastny/commonjs_modules'
  s.summary     = "CommonJS-like module system for Ruby"
  s.description = "#{s.summary}. Do not pollute the global namespace, use explicit declarations and separated namespaces."
  s.license     = 'MIT'
  s.files       = Dir.glob('{lib,spec,examples}/**/*.rb') + ['README.md']
end
