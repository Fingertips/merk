require 'merk/formatter'
require 'merk/parser'

module Merk
  def self.parser
    @parser || Merk::Parser.new
  end

  def self.render(text)
    Merk::Formatter.new(parser.parse(text)).to_html
  end
end