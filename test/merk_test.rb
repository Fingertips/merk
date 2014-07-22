require_relative 'helper'

class MerkTest < MiniTest::Unit::TestCase
  def test_render
    assert_equal '', Merk.render('')
    assert_equal '<p>Merk</p>', Merk.render('Merk')
  end

  unless $0 == __FILE__
    def test_fuzz
      100.times do
        Merk.render(fuzz)
      end
    end
  end

  private

  SPECIAL = {
    1 => "\n\n",
    2 => "\n",
    3 => '*',
    4 => '`',
    5 => '#'
  }

  def fuzz
    out = ''
    rand(2500).times do
      if char = SPECIAL[rand(10)]
        out << char
      else
        out << [rand(256)].pack('U')
      end
    end
    out
  end
end