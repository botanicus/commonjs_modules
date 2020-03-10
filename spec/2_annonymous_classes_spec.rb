require 'import'

describe 'Kernel#import', path: 'examples/2_annonymous_classes' do
  subject do |example|
    import(example.metadata[:path])
  end

  describe '_FILE_' do
    it -> (example) { eql(example.metadata[:path]) }
  end

  describe 'annonymous classes' do
    describe '.name' do
      context 'using explicit exports' do
        it "defines the right .name" do
          expect(subject.Task.name).to eql('Task')
        end

        it "overrides the .inspect method" do
          expect(subject.Task.inspect).to eql('Task')
        end
      end

      context 'using implicit exports' do
        it "exists with the right name" do
          expect { subject.ScheduledTask }.not_to raise_error
          expect(subject.ScheduledTask).to be_kind_of(Class)
        end
      end
    end
  end
end
