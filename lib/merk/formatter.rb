require 'erb'

module Merk
  class Renderer
    def initialize(ast, options={})
      @ast = ast
      @options = options
    end

    def render
      format(@ast)
    end

    def format(ast, depth=0)
      case ast
      when String, Parslet::Slice
        format_literal(ast.to_s, depth)
      when Array
        format_items(ast, depth)
      else
        format_tree(ast, depth)
      end
    end

    def call(name, contents, depth=0)
      prefix = (' ' * depth)
      case name
      when :newline
        contents.to_s
      when :literal
        prefix + contents.to_s
      else
        prefix + name.to_s + ":\n" + format(contents, depth + 1)
      end
    end

    def format_literal(input, depth=0)
      call(:literal, input, depth).to_s
    end

    def format_items(list, depth=0)
      list.inject('') { |out, item| out + format(item, depth) }
    end

    def format_tree(tree, depth=0)
      tree.inject('') do |out, (name, contents)|
        out + call(name, contents, depth + 1).to_s
      end
    end

    def escape(contents)
      contents
    end
  end

  class HTMLRenderer < Renderer
    def call(name, contents, depth=0)
      case name
      when :paragraph
        content_tag('p', format(contents))
      when :heading
        content_tag('h2', format(contents))
      when :unordered_list
        content_tag('ul', format(contents).strip)
      when :list_item
        content_tag('li', format(contents))
      when :codeblock
        content_tag('pre', content_tag('code', format(contents).strip))
      when :line
        escape(contents) + "\n"
      when :blockquote
        content_tag('blockquote', format(contents).rstrip)
      when :quoted_line
        escape(contents)
      when :emphasis
        content_tag('em', format(contents))
      when :codespan
        content_tag('code', format(contents))
      when :cloze
        content_tag('span', format(contents), class: %w(blank))
      when :c
        format(contents)
      else
        escape(contents.to_s)
      end
    end

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
      '<' + tag_name.to_s + tag_options(options) + '>' + contents + '</' + tag_name.to_s + '>'
    end
  end

  class Formatter
    def initialize(ast, options={})
      @ast = ast
      @options = options
    end

    def renderer
      @options[:render] || Merk::HTMLRenderer
    end

    def to_s
      if @ast.respond_to?(:each)
        renderer.new(@ast, @options).render
      else
        ''
      end
    end
  end
end