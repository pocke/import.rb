require 'test/unit'
require_relative '../lib/import'

class TestImport < Test::Unit::TestCase
  def test_import
    sample = Import.import('./data/sample')
    assert{sample.is_a? Import::Namespace}
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

  def test_import_with_require
    foo = Import.import('./data/require/main')::Foo
    assert{foo.new.hoge == 'hoge'}
    assert{foo::Bar.new.fuga == 'fuga'}
    assert{(defined? ::Foo).nil?}
  end

  def test_import_relative
    m = Import.import_relative('data/relative.rb')::Mod::Sample
    assert{m.new.greeting == 'hello'}

    assert_raise LoadError do
      Import.import_relative 'data/bad_relative.rb'
    end
  end

  def test_global
    Import.global
    assert{defined?(import) == 'method'}

    s = import('./data/sample.rb')::Sample
    assert{s.new.greeting == 'hello'}
    assert{(defined? ::Sample).nil?}
  end
end
