require 'import'

describe 'Kernel#import', path: 'examples/9_using_import' do
  subject do |example|
    import(example.metadata[:path])
  end

  describe '_FILE_' do
    it { |example| eql(example.metadata[:path]) }
  end

  describe 'variables' do
    it do
      expect { subject.method_using_imported_library_as_a_constant }.not_to raise_error
    end

    it do
      expect { subject.method_using_imported_library_as_a_variable }.to raise_error(NoMethodError)
    end

    it do
      expect { subject.method_using_kernel_methods }.to raise_error(NoMethodError)
    end
  end
end
