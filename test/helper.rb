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
        html: "<p>&lt;i&gt;Escaped&lt;/i&gt;</p>"
      },
      {
        input: "## Café", 
        ast: [{paragraph: [{c: {c: [{c: "#"}, {c: "#"}, {c: " "}, {c: "C"}, {c: "a"}, {c: "f"}, {c: "é"}]}}]}],
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
        input: "#\$ something",
        ast: [{paragraph: [{c: {c: [{c: "#"}, {c: "$"}, {c: " "}, {c: "s"}, {c: "o"}, {c: "m"}, {c: "e"}, {c: "t"}, {c: "h"}, {c: "i"}, {c: "n"}, {c: "g"}]}}]}],
        html: "<p>#\$ something</p>"
      },
      {
        input: "- Wrong list item",
        ast: [{ unordered_list: [{list_item: 'Wrong list item'}] }],
        html: "<ul><li>Wrong list item</li></ul>"
      },
      {
        input: "- Wrong list item with a - dash\n",
        ast: [{unordered_list: [{list_item: "Wrong list item with a - dash", newline: "\n"}]}],
        html: "<ul><li>Wrong list item with a - dash</li></ul>"
      },
      {
        input: "* List item\n",
        ast: [{unordered_list: [{list_item: "List item", newline: "\n"}]}],
        html: "<ul><li>List item</li></ul>"
      },
      {
        input: "* List item with a * star\n",
        ast: [{unordered_list: [{list_item: "List item with a * star", newline: "\n"}]}],
        html: "<ul><li>List item with a * star</li></ul>"
      },
      {
        input: "- Wrong list item one\n- Wrong list item two\n",
        ast: [{unordered_list: [{list_item: "Wrong list item one", newline: "\n"}, {list_item: "Wrong list item two", newline: "\n"}]}],
        html: "<ul><li>Wrong list item one</li>\n<li>Wrong list item two</li></ul>"
      },
      {
        input: "* List item one\n* List item two\n",
        ast: [{unordered_list: [{list_item: "List item one", newline: "\n"}, {list_item: "List item two", newline: "\n"}]}],
        html: "<ul><li>List item one</li>\n<li>List item two</li></ul>"
      },
      {
        input: "* List item one\n* List item two",
        ast: [{unordered_list: [{list_item: "List item one", newline: "\n"}, {list_item: "List item two"}]}],
        html: "<ul><li>List item one</li>\n<li>List item two</li></ul>"
      },
      {
        input: "* Red\r\n* Green\r\n* Blue\r\n\r\n",
        ast: [{unordered_list: [{list_item: "Red", newline: "\n"}, {list_item: "Green", newline: "\n"}, {list_item: "Blue", newline: "\n"}]}],
        html: "<ul><li>Red</li>\n<li>Green</li>\n<li>Blue</li></ul>"
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
        ast: [{paragraph: [{c: {c: [{c: " "}, {c: "*"}, {c: " "}, {c: "Y"}, {c: "O"}, {c: "L"}, {c: "O"}, {c: " "}, {c: "*"}, {c: " "}]}}]}],
        html: "<p> * YOLO * </p>"
      },
      {
        input: "  a = 1\n",
        ast: [{paragraph: [{c: {c: [{c: " "}, {c: " "}, {c: "a"}, {c: " "}, {c: "="}, {c: " "}, {c: "1"}], newline: "\n"}}]}],
        html: "<p>  a = 1\n</p>"
      },
      {
        input: "\tstupid\n",
        ast: [{ codeblock: [{line: 'stupid'}] }],
        html: "<pre><code>stupid</code></pre>"
      },
      {
        input: "    begin\n      a = 1\n    end\n",
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
        ast: [{blockquote: [{quoted_line: "I love quotes", newline: "\n"}, {quoted_line: "I love quotes", newline: "\n"}]}],
        html: "<blockquote>I love quotes\nI love quotes</blockquote>"
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