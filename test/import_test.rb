require 'test/unit'
require_relative '../lib/import'

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

  def test_global
    Import.global
    assert{defined?(import) == 'method'}

    s = import('./data/sample.rb')::Sample
    assert{s.new.greeting == 'hello'}
    assert{(defined? ::Sample).nil?}
  end
end
