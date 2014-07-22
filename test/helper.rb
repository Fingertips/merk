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
        ast: '',
        html: ""
      },
      {
        input: "\n\n",
        ast: '',
        html: ""
      },
      {
        input: "\n\nCafé",
        ast: [{paragraph: [{c: {c: [{c: "C"}, {c: "a"}, {c: "f"}, {c: "é"}]}}]}],
        html: "<p>Café</p>"
      },
      {
        input: "\n\nCafé\nCafé\n\nCafé\n\n\nCafé\n\n\n\nCafé\n\n\n\n\nCafé\n\n\n\n\n\nCafé\nCafé",
        ast: [{paragraph: [{c: {c: [{c: "C"}, {c: "a"}, {c: "f"}, {c: "é"}], newline: "\n"}}, {c: {c: [{c: "C"}, {c: "a"}, {c: "f"}, {c: "é"}], newline: "\n"}}]}, {paragraph: [{c: {c: [{c: "C"}, {c: "a"}, {c: "f"}, {c: "é"}], newline: "\n"}}]}, {paragraph: [{c: {c: [{c: "C"}, {c: "a"}, {c: "f"}, {c: "é"}], newline: "\n"}}]}, {paragraph: [{c: {c: [{c: "C"}, {c: "a"}, {c: "f"}, {c: "é"}], newline: "\n"}}]}, {paragraph: [{c: {c: [{c: "C"}, {c: "a"}, {c: "f"}, {c: "é"}], newline: "\n"}}]}, {paragraph: [{c: {c: [{c: "C"}, {c: "a"}, {c: "f"}, {c: "é"}], newline: "\n"}}, {c: {c: [{c: "C"}, {c: "a"}, {c: "f"}, {c: "é"}]}}]}],
        html: "<p>Café\nCafé\n</p><p>Café\n</p><p>Café\n</p><p>Café\n</p><p>Café\n</p><p>Café\nCafé</p>"
      },
      {
        input: "Café",
        ast: [{paragraph: [{c: {c: [{c: "C"}, {c: "a"}, {c: "f"}, {c: "é"}]}}]}],
        html: "<p>Café</p>"
      },
      {
        input: "<i>Escaped</i>",
        ast: [{paragraph: [{c: {c: [{c: "<"}, {c: "i"}, {c: ">"}, {c: "E"}, {c: "s"}, {c: "c"}, {c: "a"}, {c: "p"}, {c: "e"}, {c: "d"}, {c: "<"}, {c: "/"}, {c: "i"}, {c: ">"}]}}]}],
        html: "<p>&lt;i>Escaped&lt;/i></p>"
      },
      {
        input: "## Café", 
        ast: [{paragraph: [{c: {c: [{c: "#"}, {c: "#"}, {c: " "}, {c: "C"}, {c: "a"}, {c: "f"}, {c: "é"}]}}]}]  ,
        html: "<p>## Café</p>"
      },
      {
        input: "# Drinking Coffee at a Café",
        ast: [{ heading: 'Drinking Coffee at a Café' }],
        html: "<h2>Drinking Coffee at a Café</h2>"
      },
      {
        input: "# Drinking * Coffee * at a Café",
        ast: [{ heading: 'Drinking * Coffee * at a Café' }],
        html: "<h2>Drinking * Coffee * at a Café</h2>"
      },
      {
        input: "* List item\n",
        ast: [{ unordered_list: [{list_item: 'List item'}] }],
        html: "<ul><li>List item</li></ul>"
      },
      {
        input: "* List item one\n* List item two\n",
        ast: [{ unordered_list: [{list_item: 'List item one'}, {list_item: 'List item two'}] }],
        html: "<ul><li>List item one</li><li>List item two</li></ul>"
      },
      {
        input: "* Red\r\n* Green\r\n* Blue\r\n\r\n",
        ast: [{unordered_list: [{list_item: "Red"}, {list_item: "Green"}, {list_item: "Blue"}, {newline: "\n"}]}],
        html: "<ul><li>Red</li><li>Green</li><li>Blue</li>\n</ul>"
      },
      {
        input: "# A Story of two Cities\n\nThey could not win.",
        ast: [{heading: "A Story of two Cities"}, {paragraph: [{c: {c: [{c: "T"}, {c: "h"}, {c: "e"}, {c: "y"}, {c: " "}, {c: "c"}, {c: "o"}, {c: "u"}, {c: "l"}, {c: "d"}, {c: " "}, {c: "n"}, {c: "o"}, {c: "t"}, {c: " "}, {c: "w"}, {c: "i"}, {c: "n"}, {c: "."}]}}]}],
        html: "<h2>A Story of two Cities</h2><p>They could not win.</p>"
      },
      {
        input: "# A Story of two Cities\n\nThey could not win.\nBut they may no lose.",
        ast: [{heading: "A Story of two Cities"}, {paragraph: [{c: {c: [{c: "T"}, {c: "h"}, {c: "e"}, {c: "y"}, {c: " "}, {c: "c"}, {c: "o"}, {c: "u"}, {c: "l"}, {c: "d"}, {c: " "}, {c: "n"}, {c: "o"}, {c: "t"}, {c: " "}, {c: "w"}, {c: "i"}, {c: "n"}, {c: "."}], newline: "\n"}}, {c: {c: [{c: "B"}, {c: "u"}, {c: "t"}, {c: " "}, {c: "t"}, {c: "h"}, {c: "e"}, {c: "y"}, {c: " "}, {c: "m"}, {c: "a"}, {c: "y"}, {c: " "}, {c: "n"}, {c: "o"}, {c: " "}, {c: "l"}, {c: "o"}, {c: "s"}, {c: "e"}, {c: "."}]}}]}],
        html: "<h2>A Story of two Cities</h2><p>They could not win.\nBut they may no lose.</p>"
      },
      {
        input: "*YOLO*",
        ast: [{paragraph: [{c: {c: [{emphasis: "YOLO"}]}}]}],
        html: "<p><em>YOLO</em></p>"
      },
      {
        input: " * YOLO * ",
        ast: [{paragraph: [{c: {c: [{c: " "}, {emphasis: " YOLO "}, {c: " "}]}}]}],
        html: "<p> <em> YOLO </em> </p>"
      },
      {
        input: "  begin\n    a = 1\n  end\n",
        ast: [{ codeblock: [{line: 'begin'}, {line: '  a = 1'}, {line: 'end'}] }],
        html: "<pre><code>begin\n  a = 1\nend</code></pre>"
      },
      {
        input: "`code`",
        ast: [{paragraph: [{c: {c: [{codespan: "code"}]}}]}],
        html: "<p><code>code</code></p>"
      },
      {
        input: "> I love quotes\n> I love quotes\n",
        ast: [{ blockquote: [{quoted_line: 'I love quotes'}, {quoted_line: 'I love quotes'}] }],
        html: "<blockquote>I love quotes\nI love quotes</blockquote>"
      },
      {
        input: "Here's some text. Let’s make a list:\n\n\n* Red\n* Green\n* Blue\n\n# This is a section header\n\nThis is paragraph of text *with emphasis* and some `print(\"inline code\")` as well.\n\n> This is a blockquote.\n> And this\n\n  This is a code block.\n",
        ast: [{paragraph: [{c: {c: [{c: "H"}, {c: "e"}, {c: "r"}, {c: "e"}, {c: "'"}, {c: "s"}, {c: " "}, {c: "s"}, {c: "o"}, {c: "m"}, {c: "e"}, {c: " "}, {c: "t"}, {c: "e"}, {c: "x"}, {c: "t"}, {c: "."}, {c: " "}, {c: "L"}, {c: "e"}, {c: "t"}, {c: "’"}, {c: "s"}, {c: " "}, {c: "m"}, {c: "a"}, {c: "k"}, {c: "e"}, {c: " "}, {c: "a"}, {c: " "}, {c: "l"}, {c: "i"}, {c: "s"}, {c: "t"}, {c: ":"}], newline: "\n"}}]}, {unordered_list: [{list_item: "Red"}, {list_item: "Green"}, {list_item: "Blue"}, {newline: "\n"}]}, {heading: "This is a section header"}, {paragraph: [{c: {c: [{c: "T"}, {c: "h"}, {c: "i"}, {c: "s"}, {c: " "}, {c: "i"}, {c: "s"}, {c: " "}, {c: "p"}, {c: "a"}, {c: "r"}, {c: "a"}, {c: "g"}, {c: "r"}, {c: "a"}, {c: "p"}, {c: "h"}, {c: " "}, {c: "o"}, {c: "f"}, {c: " "}, {c: "t"}, {c: "e"}, {c: "x"}, {c: "t"}, {c: " "}, {emphasis: "with emphasis"}, {c: " "}, {c: "a"}, {c: "n"}, {c: "d"}, {c: " "}, {c: "s"}, {c: "o"}, {c: "m"}, {c: "e"}, {c: " "}, {codespan: "print(\"inline code\")"}, {c: " "}, {c: "a"}, {c: "s"}, {c: " "}, {c: "w"}, {c: "e"}, {c: "l"}, {c: "l"}, {c: "."}], newline: "\n"}}]}, {blockquote: [{quoted_line: "This is a blockquote."}, {quoted_line: "And this"}]}, {codeblock: [{line: "This is a code block."}]}],
        html: "<p>Here's some text. Let’s make a list:\n</p><ul><li>Red</li><li>Green</li><li>Blue</li>\n</ul><h2>This is a section header</h2><p>This is paragraph of text <em>with emphasis</em> and some <code>print(\"inline code\")</code> as well.\n</p><blockquote>This is a blockquote.\nAnd this</blockquote><pre><code>This is a code block.</code></pre>"
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