require 'merk/formatter'
require 'merk/parser'

module Merk
  def self.parser
    @parser || Merk::Parser.new
  end

  def self.render(text, options={})
    Merk::Formatter.new(parser.parse(text), options).to_s
  end
end