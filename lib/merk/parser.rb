require 'parslet' 

module Merk
  class Parser < Parslet::Parser
    rule(:newline) { match(/\n/) }
    rule(:newline?) { newline.maybe }
    rule(:newlines) { newline >> newline }

    rule(:hash) { match['#'] }
    rule(:star) { match['*'] }
    rule(:space) { match[' '] }

    rule(:char) { match['[:alpha:]'] }

    rule(:literal) { char | space | star | hash }

    rule(:inline) { emphasis.as(:emphasis) | literal.as(:literal) }
    rule(:inlines) { inline.repeat }

    rule(:literals_without_star) { (char | space | hash).repeat }
    rule(:emphasis) { star >> literals_without_star.as(:literal) >> star }

    rule(:heading) { hash >> space >> literals.as(:literal) }

    rule(:paragraph) { inlines.as(:inline) }

    rule(:unordered_list_item) { star >> space >> literals_without_star.as(:list_item) >> newline }

    rule(:unordered_list) { unordered_list_item.repeat }

    rule(:block) {
      unordered_list.as(:unordered_list) |
      heading.as(:heading) |
      paragraph.as(:paragraph)
    }
    rule(:blocks) { newlines | block.repeat }

    rule(:document) { newlines | newline | blocks }

    root(:document)
  end
end