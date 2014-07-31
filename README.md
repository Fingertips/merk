# Merk

Merk parses and formats a subset of Markdown.

# Usage

    require 'merk'
    Merk.render(input)

## Overriding rendering

    class Renderer
      def initialize(node_name)
      end

      def self.[](node_name)
        new(node_name)
      end
    end

    Merk.render(input, format: Renderer
      end
    })

Note that you need to call `format` to render any additional nodes included in the content. The `content_tag` method only escapes attribute values and not the tag content. When you want to escape the content, call `escape`.

# License

Copyright Manfred Stienstra <manfred@fngtps.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.