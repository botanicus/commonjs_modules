require 'import'

paths = [
  'examples/5_default_import/exporting_annonymous_class.rb',
  'examples/5_default_import/exporting_class.rb',
  'examples/5_default_import/using_export.rb',
  'examples/5_default_import/using_export_with_block.rb',
  'examples/5_default_import/using_module.rb'
]

paths.each do |path|
  describe 'Kernel#import', path: path do
    subject do |example|
      import(example.metadata[:path])
    end

    describe '_FILE_' do
      it -> (example) { eql(example.metadata[:path]) }
    end

    describe 'default' do
      it { should be_kind_of(Class) }
    end
  end
end
