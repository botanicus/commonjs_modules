#!/usr/bin/env spec --colour --format specdoc
# encoding: utf-8

# Make Ruby 1.9.2 happy
$: << File.expand_path(".")

require "import"

describe "Kernel#import" do
  before(:each) do
    @sys = import("example")
  end

  describe "variables" do
    it "should be able to define a variable using exports.setter = value" do
      @sys.language.should eql("Ruby")
    end
  end

  describe "constants" do
    it "should be able to define a constant using exports.setter = value" do
      @sys.VERSION_.should eql("0.0.1")
    end

    it "should not mess with the global namespace" do
      defined?(VERSION_).should eql(nil)
    end
  end

  describe "methods" do
    it "should be able to define a method using def exports.a_method" do
      @sys.say_hello.should eql("Hello World!")
    end
  end
end
