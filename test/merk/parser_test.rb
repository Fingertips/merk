require_relative '../helper'

class Merk::ParserTest < MiniTest::Unit::TestCase
  def test_parser_units
    examples.each do |example|
      assert_parses(example)
    end
  end

  def test_parser_files
    examples_from_files.each do |example|
      if example[:input] && example[:ast]
        assert_parses(example)
      end
    end
  end
  
  private

  def parse(input)
    parser = Merk::Parser.new
    parser.parse(input)
  end

  def assert_parses(example)
    actual = parse(example[:input])
    line = '-' * 80
    message = [
      nil,
      line,
      'INPUT: ' + example[:input].inspect,
      line,
      'AST:',
      actual.inspect,
      line,
      nil
    ].join("\n")
    assert_equal(example[:ast], actual, message)
  end
end
