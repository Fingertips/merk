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

    rule(:heading) { str('#') >> whitespace >> text.as(:heading) }

    rule(:blockquote) { (quoted_line >> newline).repeat(1) }
    rule(:quoted_line) { str('>') >> space >> text.as(:quoted_line) }

    rule(:indent) { space.repeat(4,4) | tab }
    rule(:codeblock) { (codeblock_line >> newline).repeat(1) }
    rule(:codeblock_line) { indent >> text.as(:line) }

    rule(:unordered_list) {
      (unordered_list_item >> newline).repeat(1) >> newline? |
      unordered_list_item >> newline?
    }
    rule(:unordered_list_item) {
      str('*') >> whitespace >> char.repeat(1).as(:list_item) |
      str('-') >> whitespace >> char.repeat(1).as(:list_item)
    }

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

    rule(:emphasis) { str('*') >> emphasis_body.as(:emphasis) >> str('*') }
    rule(:codespan) { str('`') >> match['^\n\`'].repeat(1).as(:codespan) >> str('`') }

    rule(:emphasis_body) { match['^\s\ '] >> match['^\n\*'].repeat(1) }

    rule(:char) { match['^\n'] }
    rule(:text) { char.repeat(1) }

    rule(:newline) { match['\n'] }
    rule(:newline?) { newline.as(:newline) | any.absent? }

    rule(:tab) { match['\t'] }
    rule(:space) { str(' ') }
    rule(:whitespace) { space.repeat(1) }

    def parse(text)
      text = cleanup(text)
      (text == "\n") ? '' : super(text)
    end

    private

    def cleanup(text)
      text.gsub(/\r\n/, "\n").gsub(/\A\n+/, '')
    end
  end
end