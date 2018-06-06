require 'import'

describe 'Kernel#import' do
  subject { import('examples/2_annonymous_classes') }

  describe 'annonymous classes' do
    describe '.name' do
      context 'using explicit exports' do
        it "defines the right name" do
          expect(subject.Task.name).to eql('Task')
        end
      end

      context 'using implicit exports' do
        it "exists with the right name" do
          expect { subject.ScheduledTask_II }.not_to raise_error
          expect(subject.ScheduledTask_II).to be_kind_of(Class)
        end
      end
    end
  end
end

