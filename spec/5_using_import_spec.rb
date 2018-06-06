require 'import'

describe 'Kernel#import' do
  subject { import('examples/5_using_import') }

  describe 'variables' do
    it do
      expect { subject.method_using_imported_library_as_a_constant }.not_to raise_error
    end

    it do
      expect { subject.method_using_imported_library_as_a_variable }.to raise_error
    end

    it do
      expect { subject.method_using_kernel_methods }.to raise_error
    end
  end
end

