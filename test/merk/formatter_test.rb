require_relative '../helper'

class Merk::FormatterTest < MiniTest::Unit::TestCase
  def test_parser_units
    examples.each do |example|
      assert_parses(example)
    end
  end

  def test_parser_files
    examples_from_files.each do |example|
      if example[:ast] && example[:html]
        assert_parses(example)
      end
    end
  end

  private

  def format(ast)
    formatter = Merk::Formatter.new(ast)
    formatter.to_html
  end

  def assert_parses(example)
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
