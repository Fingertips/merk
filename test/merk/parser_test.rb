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

  def format_ast(input)
    input.gsub(/:(\w+)=>/, '\1: ').gsub(/@\d+/, '')
  end

  def assert_parses(example)
    line = '-' * 80
    actual = parse(example[:input])
    message = [
      nil,
      line,
      'INPUT: ' + example[:input].inspect,
      line,
      'AST:',
      actual.inspect,
      'FORMATTED AST:',
      format_ast(actual.inspect),
      line,
      nil
    ].join("\n")
    assert_equal(example[:ast], actual, message)
  rescue Parslet::ParseFailed => failure
    refute(true, "\n" + '-'*80 + "\n" + example[:input] + "\n" + '-'*80 + "\n" + failure.cause.ascii_tree)
  end
end
