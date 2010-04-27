#!/usr/bin/env spec --colour --format specdoc
# encoding: utf-8

# Make Ruby 1.9.2 happy
$: << File.expand_path(".")

require "import"

describe "Kernel#import" do
  before(:all) do
    @sys = import("example")
  end

  describe "variables" do
    it "should be able to define a variable using exports.setter = value" do
      @sys.language.should eql("Ruby")
    end

    it "should register variables" do
      @sys.data[:language].should eql("Ruby")
    end
  end

  describe "constants" do
    it "should be able to define a constant using exports.setter = value" do
      @sys.VERSION_.should eql("0.0.1")
    end

    it "should not mess with the global namespace" do
      defined?(VERSION_).should eql(nil)
    end

    it "should register constants" do
      @sys.data[:VERSION_].should eql("0.0.1")
    end
  end

  describe "methods" do
    it "should be able to define a method using def exports.a_method" do
      p @sys
      @sys.say_hello.should eql("Hello World!")
    end

    it "should register methods" do
      @sys.data[:say_hello].should eql(@sys.method(:say_hello))
    end
  end
end
