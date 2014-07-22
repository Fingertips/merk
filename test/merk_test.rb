require_relative 'helper'

class MerkTest < MiniTest::Unit::TestCase
  def test_render
    assert_equal '', Merk.render('')
    assert_equal '<p>Merk</p>', Merk.render('Merk')
  end
end