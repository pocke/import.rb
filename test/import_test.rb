require 'test/unit'
require 'import'

class TestImport < Test::Unit::TestCase
  def test_import
    sample = Import.import('./data/sample')
    assert{sample::Sample.is_a? Class}
    assert{sample::Sample.new.greeting == 'hello'}
    assert{(defined? ::Sample).nil?}

    assert_raise LoadError do
      Import.import('does_not_exist_feature')
    end
  end

  def test_import_recursion
    re = Import.import('./data/recursion')::Recursion
    assert{re.greeting == 'hello'}
  end
end
