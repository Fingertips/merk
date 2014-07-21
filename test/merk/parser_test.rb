require 'rubygems'
require 'minitest/autorun'

$:.unshift(File.expand_path('../../../lib', __FILE__))

require 'merk'

class Merk::ParserTest < MiniTest::Unit::TestCase
  def test_parser
    [
      "\n",
      "\n\n",
      'Hi',
      '# Hi',
      '# Hi there',
      '# Hi there *you* person',
      "* One\n* Two\n",
      "# Hi\n\nPara"
    ].each do |input|
      puts '-' * 80
      puts input
      puts '-' * 80
      puts '>> ' + parse(input).inspect
    end
  end

  private

  def parse(input)
    parser = Merk::Parser.new
    parser.parse(input)
  rescue Parslet::ParseFailed => exception
    puts exception.cause.ascii_tree
  end
end