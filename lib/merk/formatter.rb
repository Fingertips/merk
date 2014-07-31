require 'erb'

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
          out + content_tag('ul', format(contents).strip)
        when :list_item
          out + content_tag('li', format(contents))
        when :codeblock
          out + content_tag('pre', content_tag('code', format(contents).strip))
        when :line
          out + escape(contents) + "\n"
        when :blockquote
          out + content_tag('blockquote', format(contents).rstrip)
        when :quoted_line
          out + escape(contents)
        when :emphasis
          out + content_tag('em', format(contents))
        when :codespan
          out + content_tag('code', format(contents))
        when :cloze
          out + content_tag('span', format(contents), class: %w(cloze))
        when :c, :inline
          out + format(contents)
        else
          out + escape(contents.to_s)
        end
      end
    end

    BOOLEAN_ATTRIBUTES = %w(selected autof)

    def escape(input)
      ERB::Util.html_escape(input)
    end
    
    def format_attribute_value(value)
      if value.kind_of?(Array)
        value = value.join(' ')
      end
      escape(value)
    end

    def tag_option(name, value)
      name.to_s + '="' + format_attribute_value(value) + '"'
    end

    def tag_options(options)
      attributes = []

      unless options.nil? || options.empty?
        options.each do |name, value|
          attributes << tag_option(name, value)
        end
      end

      if attributes.empty?
        ''
      else
        ' ' + attributes.join(' ')
      end
    end

    def content_tag(tag_name, contents, options=nil)
      '<' + tag_name + tag_options(options) + '>' + contents + '</' + tag_name + '>'
    end
  end
end