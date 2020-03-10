require 'import'

describe 'Kernel#import', path: 'examples/1_basic' do
  subject do |example|
    import(example.metadata[:path])
  end

  # Shouldn't this be an absolute path?
  describe '_FILE_' do
    it "is being set correctly" do |example|
      expect(subject._FILE_).to eql(example.metadata[:path])
    end
  end

  describe 'variables' do
    it "defines a variable using exports.setter = value" do
      expect(subject.language).to eql('Ruby')
    end

    it "registers variables" do
      expect(subject._DATA_[:language]).to eql('Ruby')
    end
  end

  describe 'constants' do
    it "defines a constant using exports.setter = value" do
      expect(subject.VERSION_).to eql('0.0.1')
    end

    it "doesn't mess up the global namespace" do
      expect(defined?(VERSION_)).to eql(nil)
    end

    it "should register constants" do
      expect(subject._DATA_[:VERSION_]).to eql('0.0.1')
    end
  end

  describe 'methods' do
    it "defines a method using def exports.a_method" do
      expect(subject.say_hello).to eql("Hello World!")
    end

    it "registers methods" do
      expect(subject._DATA_[:say_hello]).to be_kind_of(Method)
    end

    it "overrides the #inspect method" do
      expect(subject._DATA_[:say_hello].inspect).to eql('#<Method #say_hello>')
    end
  end
end
