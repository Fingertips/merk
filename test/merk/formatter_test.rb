# encoding: utf-8

require_relative '../helper'

class Merk::FormatterTest < MiniTest::Unit::TestCase
  def test_formatter_units
    examples.each do |example|
      assert_formats(example)
    end
  end

  def test_formatter_files
    examples_from_files.each do |example|
      if example[:ast] && example[:html]
        assert_formats(example)
      end
    end
  end

  private

  def format(ast)
    formatter = Merk::Formatter.new(ast)
    formatter.to_s
  end

  def assert_formats(example)
    actual = format(example[:ast])
    line = '-' * 80
    message = [
      nil,
      line,
    'AST: ' + example[:ast].inspect,
      line,
      'HTML:',
      actual.inspect,
      line,
      nil
    ].join("\n")
    assert_equal(example[:html], actual, message)
  end
end
