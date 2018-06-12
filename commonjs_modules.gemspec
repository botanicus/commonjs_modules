#!/usr/bin/env gem build
# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'commonjs_modules'
  s.version     = '0.0.1'
  s.authors     = ['James C Russell']
  s.email       = 'james@101ideas.cz'
  s.homepage    = 'http://github.com/botanicus/commonjs_modules'
  s.summary     = ''
  s.description = "#{s.summary}."
  s.license     = 'MIT'
  s.files       = Dir.glob('{lib,examples}/**/*.rb') + ['README.md']
end
