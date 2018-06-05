#!/usr/bin/env spec --colour --format specdoc

# Make Ruby 1.9.2 happy
$: << File.expand_path(".")

require "import"

describe "Kernel#import" do
  before(:all) do
    @sys = import("example")
  end

  describe "variables" do
    it "should be able to define a variable using exports.setter = value" do
      expect(@sys.language).to eql("Ruby")
    end

    it "should register variables" do
      expect(@sys.data[:language]).to eql("Ruby")
    end
  end

  describe "constants" do
    it "should be able to define a constant using exports.setter = value" do
      expect(@sys.VERSION_).to eql("0.0.1")
    end

    it "should not mess with the global namespace" do
      expect(defined?(VERSION_)).to eql(nil)
    end

    it "should register constants" do
      expect(@sys.data[:VERSION_]).to eql("0.0.1")
    end
  end

  describe "methods" do
    it "should be able to define a method using def exports.a_method" do
      expect(@sys.say_hello).to eql("Hello World!")
    end

    it "should register methods" do
      expect(@sys.data[:say_hello]).to eql(@sys.method(:say_hello))
    end
  end

  describe "classes" do
    describe '#inspect' do
      it "shows the right name" do
        expect(@sys.Task.inspect).to eql(:Task)
      end
    end
  end
end
