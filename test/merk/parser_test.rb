require_relative '../helper'

class Merk::ParserTest < MiniTest::Unit::TestCase
  def test_parser
    examples.each do |example|
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

  private

  def parse(input)
    parser = Merk::Parser.new
    parser.parse(input)
  end
end
