require 'parslet' 

module Merk
  class Parser < Parslet::Parser
    root(:document)

    rule(:document) {
      block >> (newline.repeat >> block).repeat |
      newline.repeat
    }

    rule(:block) {
      heading |
      blockquote.as(:blockquote) |
      codeblock.as(:codeblock) |
      unordered_list.as(:unordered_list) |
      paragraph.as(:paragraph) |
      newline
    }

    rule(:heading) { str('#') >> whitespace >> text.as(:heading) }

    rule(:blockquote) { (quoted_line >> newline).repeat(1) }
    rule(:quoted_line) { str('>') >> space >> text.as(:quoted_line) }

    rule(:codeblock) { (codeblock_line >> newline).repeat(1) }
    rule(:codeblock_line) { space >> space >> text.as(:line) }

    rule(:unordered_list) {
      (unordered_list_item >> newline).repeat(1)
    }
    rule(:unordered_list_item) { str('*') >> space >> match['^\n\*'].repeat(1).as(:list_item) }

    rule(:paragraph) { inline.repeat(1) }

    rule(:inline) {
      emphasis |
      codespan |
      match['^\n\*\`'].repeat(1).as(:literal) |
      match['\*\`'].as(:literal)
    }

    rule(:emphasis) { str('*') >> match['^\n\*'].repeat(1).as(:emphasis) >> str('*') }
    rule(:codespan) { str('`') >> match['^\n\`'].repeat(1).as(:codespan) >> str('`') }

    rule(:text) { match['^\n'].repeat(1) }

    rule(:newline) { match['\n'] }

    rule(:space)  { match["\t "] }
    rule(:whitespace) { space.repeat }
  end
end