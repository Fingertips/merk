require 'parslet' 

module Merk
  class Parser < Parslet::Parser
    root(:document)

    rule(:document) {
      block.repeat
    }

    rule(:block) {
      newline.repeat(2) |
      heading |
      blockquote.as(:blockquote) |
      codeblock.as(:codeblock) |
      unordered_list.as(:unordered_list) |
      paragraph.as(:paragraph) |
      newline.repeat(1)
    }

    rule(:heading) { str('#') >>  match['^#'] >> whitespace >> text.as(:heading) }

    rule(:blockquote) { (quoted_line >> newline).repeat(1) }
    rule(:quoted_line) { str('>') >> space >> text.as(:quoted_line) }

    rule(:codeblock) { (codeblock_line >> newline).repeat(1) }
    rule(:codeblock_line) { space >> space >> text.as(:line) }

    rule(:unordered_list) {
      (unordered_list_item >> newline).repeat(1) >> newline?
    }
    rule(:unordered_list_item) { str('*') >> space >> match['^\n\*'].repeat(1).as(:list_item) }

    rule(:paragraph) {
      (
        (inline.repeat(1).as(:c) >> newline?).as(:c)
      ).repeat(1)
    }

    rule(:inline) {
      emphasis |
      codespan |
      char.as(:c)
    }

    rule(:emphasis) { str('*') >> match['^\n\*'].repeat(1).as(:emphasis) >> str('*') }
    rule(:codespan) { str('`') >> match['^\n\`'].repeat(1).as(:codespan) >> str('`') }

    rule(:char) { match['^\n'] }
    rule(:text) { char.repeat(1) }

    rule(:newline) { match['\n'] }
    rule(:newline?) { newline.as(:newline) | any.absent? }

    rule(:space)  { match["\t "] }
    rule(:whitespace) { space.repeat }

    def parse(text)
      text = cleanup(text)
      (text == "\n") ? '' : super(text)
    end

    private

    def cleanup(text)
      text.gsub(/\A\n+/, '').gsub(/\r\n/, "\n")
    end
  end
end