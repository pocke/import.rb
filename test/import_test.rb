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

  def test_import_with_require
    foo = Import.import('./data/require/main')::Foo
    assert{foo.new.hoge == 'hoge'}
    assert{foo::Bar.new.fuga == 'fuga'}
    assert{(defined? ::Foo).nil?}
  end

  def test_global
    Import.global
    assert{defined?(import) == 'method'}

    s = import('./data/sample.rb')::Sample
    assert{s.new.greeting == 'hello'}
    assert{(defined? ::Sample).nil?}
  end

  def test_with_replace_method
    a = 1

    Import.__send__(:with_replace_method, :eval, -> (i) { a += i }) do
      eval(10)
    end

    assert{a == 11}
    assert{eval("1+1") == 2}
  end

  def test_new_require_gen
    p = Import.__send__(:new_require_gen, Module.new)

    assert{p.is_a? Proc}
    assert{p.parameters.length == 1}
  end
end
