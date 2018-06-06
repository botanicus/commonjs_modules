require 'import'

describe 'Kernel#import' do
  subject { import('examples/4_classic_classes_implicit') }

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



