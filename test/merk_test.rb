require_relative 'helper'

class MyRenderer < Merk::HTMLRenderer
  def call(name, contents, depth)
    case name
    when :paragraph
      content_tag(:p, format(contents), class: %w(my))
    else
      super
    end
  end
end

class MerkTest < MiniTest::Unit::TestCase
  def test_render
    assert_equal '', Merk.render('')
    assert_equal '<p>Merk</p>', Merk.render('Merk')
  end

  def test_render_with_renderer
    assert_equal '', Merk.render('', render: MyRenderer)
    assert_equal '<p class="my">Merk</p>', Merk.render('Merk', render: MyRenderer)
  end

  if $0 == __FILE__ || ENV['CI']
    def test_fuzz
      100.times do
        Merk.render(fuzz)
      end
    end
  end

  private

  FUZZ = {
    1 => "\n\n",
    2 => "\n",
    3 => '*',
    4 => '`',
    5 => '#'
  }

  def fuzz
    out = ''
    rand(2500).times do
      if char = FUZZ[rand(10)]
        out << char
      else
        out << [rand(256)].pack('U')
      end
    end
    out
  end
end