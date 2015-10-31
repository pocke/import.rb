require 'test/unit'
require 'import'

class TestImport < Test::Unit::TestCase
  def test_import
    sample = Import.import('./data/sample')
    assert{sample::Sample.is_a? Class}
    assert{(defined? ::Sample).nil?}

    assert_raise LoadError do
      Import.import('does_not_exist_feature')
    end
  end
end
