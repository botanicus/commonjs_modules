require 'import'

describe 'Kernel#import', path: 'examples/3_classic_classes_module' do
  subject do |example|
    import(example.metadata[:path])
  end

  describe '__FILE__' do
    it -> (example) { eql(example.metadata[:path]) }
  end

  describe 'classes' do
    describe 'private classes' do
      it "doesn't mess up the namespace" do
        expect(defined?(PrivateClass)).to be(nil)
      end

      it "doesn't mess up the exports object" do
        expect { subject.PrivateClass }.to raise_error(NoMethodError)
      end
    end

    describe '.name' do
      context 'classic classes' do
        it "doesn't rewrite the name" do
          expect(subject._Task.name).to eql('Task')
        end
      end
    end
  end
end


