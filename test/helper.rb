# encoding: utf-8

require 'pp'
require 'rubygems'
require 'minitest/autorun'


$:.unshift(File.expand_path('../../lib', __FILE__))

require 'merk'

class MiniTest::Unit::TestCase
  protected

  def examples
    [
      {
        input: "\n",
        ast: "\n",
        html: ""
      },
      {
        input: "\n\n",
        ast: "\n\n",
        html: ""
      },
      {
        input: "Café",
        ast: { paragraph: [{ literal: 'Café' }] },
        html: "<p>Café</p>"
      },
      {
        input: "<i>Escaped</i>",
        ast: { paragraph: [{ literal: '<i>Escaped</i>' }] },
        html: "<p>&lt;i>Escaped&lt;/i></p>"
      },
      {
        input: "# Drinking Coffee at a Café",
        ast: { heading: 'Drinking Coffee at a Café' },
        html: "<h2>Drinking Coffee at a Café</h2>"
      },
      {
        input: "# Drinking * Coffee * at a Café",
        ast: { heading: 'Drinking * Coffee * at a Café' },
        html: "<h2>Drinking * Coffee * at a Café</h2>"
      },
      {
        input: "* List item\n",
        ast: { unordered_list: [{list_item: 'List item'}] },
        html: "<ul><li>List item</li></ul>"
      },
      {
        input: "* List item one\n* List item two\n",
        ast: { unordered_list: [{list_item: 'List item one'}, {list_item: 'List item two'}] },
        html: "<ul><li>List item one</li><li>List item two</li></ul>"
      },
      {
        input: "# A Story of two Cities\n\nThey cannot win.",
        ast: [{ heading: 'A Story of two Cities' }, { paragraph: [{ literal: 'They cannot win.' }] }],
        html: "<h2>A Story of two Cities</h2><p>They cannot win.</p>"
      },
      {
        input: "*YOLO*",
        ast: { paragraph: [{emphasis: 'YOLO'}] },
        html: "<p><em>YOLO</em></p>"
      },
      {
        input: " * YOLO * ",
        ast: { paragraph: [{literal: ' '}, {emphasis: ' YOLO '}, {literal: ' '}] },
        html: "<p> <em> YOLO </em> </p>"
      },
      {
        input: "  begin\n    a = 1\n  end\n",
        ast: { codeblock: [{line: 'begin'}, {line: '  a = 1'}, {line: 'end'}] },
        html: "<pre><code>begin\n  a = 1\nend</code></pre>"
      },
      {
        input: "`code`",
        ast: { paragraph: [{codespan: 'code'}] },
        html: "<p><code>code</code></p>"
      },
      {
        input: "> I love quotes\n> I love quotes\n",
        ast: { blockquote: [{quoted_line: 'I love quotes'}, {quoted_line: 'I love quotes'}] },
        html: "<blockquote>I love quotes\nI love quotes</blockquote>"
      },
      {
        input: "Here's some text. Let’s make a list:\n\n\n* Red\n* Green\n* Blue\n\n# This is a section header\n\nThis is paragraph of text *with emphasis* and some `print(\"inline code\")` as well.\n\n> This is a blockquote.\n> And this\n\n  This is a code block.\n",
        ast: [ {paragraph: [{literal: "Here's some text. Let’s make a list:"}]}, {unordered_list: [{list_item: 'Red'}, {list_item: 'Green'}, {list_item: 'Blue'}]}, {heading: 'This is a section header'}, {paragraph: [{literal: 'This is paragraph of text '}, {emphasis: 'with emphasis'}, {literal: ' and some '}, {codespan: 'print("inline code")'}, {literal: ' as well.'}]}, {blockquote: [{quoted_line: "This is a blockquote."}, {quoted_line: 'And this'}]}, {codeblock: [{line: 'This is a code block.'}]}],
        html: "<p>Here's some text. Let’s make a list:</p><ul><li>Red</li><li>Green</li><li>Blue</li></ul><h2>This is a section header</h2><p>This is paragraph of text <em>with emphasis</em> and some <code>print(\"inline code\")</code> as well.</p><blockquote>This is a blockquote.\nAnd this</blockquote><pre><code>This is a code block.</code></pre>"
      }
    ]
  end

  def examples_path
    File.expand_path('../examples', __FILE__)
  end

  def relative_path(path)
    path[examples_path.length..-1].split('.', 2)[0]
  end

  def example_from_file(filename)
    case File.extname(filename)
    when '.merk'
      { input: File.read(filename) }
    when '.ast'
      { ast: eval(File.read(filename)) }
    when '.html'
      { html: File.read(filename) }
    end
  end

  def examples_from_files
    examples = []
    Dir.glob(examples_path + '**/*.{ast,html,merk}').each do |filename|
      path = relative_path(filename)
      if example = example_from_file(filename)
        if existing = examples.find { |example| example[:path] == path }
          example.each do |key, value|
            existing[key] = value
          end
        else
          new_example = example
          new_example[:path] = path
          examples << new_example
        end
      end
    end
    examples
  end
end