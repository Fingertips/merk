module Merk
  class Formatter
    def initialize(ast)
      @ast = ast
    end

    def to_html
      if @ast.respond_to?(:each)
        format(@ast)
      else
        ''
      end
    end

    private

    def format(ast)
      case ast
      when Array
        format_items(ast)
      when String, Parslet::Slice
        escape(ast.to_s)
      else
        format_tree(ast)
      end
    end

    def format_items(list)
      list.inject('') { |out, item| out + format(item) }
    end

    def format_tree(tree)
      tree.inject('') do |out, (node_name, contents)|
        case node_name
        when :paragraph
          out + content_tag('p', format(contents))
        when :heading
          out + content_tag('h2', format(contents))
        when :unordered_list
          out + content_tag('ul', format(contents))
        when :list_item
          out + content_tag('li', format(contents))
        when :codeblock
          out + content_tag('pre', content_tag('code', format(contents).rstrip))
        when :line
          out + escape(contents) + "\n"
        when :blockquote
          out + content_tag('blockquote', format(contents).rstrip)
        when :quoted_line
          out + escape(contents) + "\n"
        when :emphasis
          out + content_tag('em', format(contents))
        when :codespan
          out + content_tag('code', format(contents))
        when :c, :inline
          out + format(contents)
        else
          out + escape(contents.to_s)
        end
      end
    end

    def content_tag(tag_name, contents)
      '<' + tag_name + '>' + contents + '</' + tag_name + '>'
    end

    def escape(input)
      input.to_s.gsub('<', '&lt;')
    end
  end
end