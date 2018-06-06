require 'import'

describe 'Kernel#import' do
  subject { import('examples/2_annonymous_classes') }

  describe 'classes' do
    describe '.name' do
      context 'annonymous classes' do
        it "shows the right name" do
          expect(subject.Task.name).to eql('Task')
        end
      end
    end
  end
end

