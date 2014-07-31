require 'erb'

module Merk
  class HTMLRenderer
    def initialize(ast, options={})
      @ast = ast
      @options = options
    end

    def render
      format(@ast)
    end

    protected

    def format(ast)
      case ast
      when String, Parslet::Slice
        format_literal(ast.to_s)
      when Array
        format_items(ast)
      else
        format_tree(ast)
      end
    end

    def format_literal(input)
      escape(input)
    end

    def format_items(list)
      list.inject('') { |out, item| out + format(item) }
    end

    def format_node(name, contents)
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
      when :c, :inline
        format(contents)
      else
        escape(contents.to_s)
      end
    end

    def format_tree(tree)
      tree.inject('') do |out, (name, contents)|
        out + format_node(name, contents)
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
      '<' + tag_name + tag_options(options) + '>' + contents + '</' + tag_name + '>'
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