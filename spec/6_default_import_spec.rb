require 'import'

describe 'Kernel#import' do
  subject { import('examples/6_default_import') }

  describe 'default' do
    it { should be_kind_of(Class) }
  end
end
