require 'test/unit'

require 'eymiha/math3/envelope3'

include Eymiha
include Eymiha::ThreeDimensions
  
class TC_Envelope3 < Test::Unit::TestCase
  
  def test_empty
    envelope3 = Envelope3.new
    assert(envelope3.count == 0)
    assert_raise(EnvelopeException) { envelope3.high }
    assert_raise(EnvelopeException) { envelope3.low }
  end
  
  def test_add
    envelope3 = Envelope3.new
    p3 = point3 1,2,3
    envelope3.add p3
    assert(envelope3.high == p3)
    assert(envelope3.low == p3)
    envelope3.add 2,4,6
    assert(envelope3.high == point3(2,4,6))
    assert(envelope3.low == point3(1,2,3))
    assert(envelope3.count == 2)
    envelope3.add point3(-3,5,-7)
    envelope3.add point3(4.5,-3,1)
    assert(envelope3.high == point3(4.5,5,6))
    assert(envelope3.low == point3(-3,-3,-7))
    assert(envelope3.count == 4)
    envelope3.add envelope3
    assert(envelope3.high == point3(4.5,5,6))
    assert(envelope3.low == point3(-3,-3,-7))
    assert(envelope3.count == 8)
    assert_raise(EnvelopeException) { envelope3.add "bad" }
    assert(envelope3.count == 8)
  end

  def test_contains
    envelope3 = Envelope3.new(1,2,3).add(3,4,5)
    assert(envelope3.contains?(1,2,3))
    assert(envelope3.contains?(3,4,5))
    assert(envelope3.contains?(2,3,4))
    assert(!(envelope3.contains?(0,3,4)))
    assert(!(envelope3.contains?(4,3,4)))
    assert(!(envelope3.contains?(2,1,4)))
    assert(!(envelope3.contains?(2,5,4)))
    assert(!(envelope3.contains?(2,3,2)))
    assert(!(envelope3.contains?(2,3,6)))
    assert(envelope3.contains?(point3(1,2,3)))
    assert(envelope3.contains?(point3(3,4,5)))
    assert(envelope3.contains?(point3(2,3,4)))
    assert(!(envelope3.contains?(point3(0,3,4))))
    assert(!(envelope3.contains?(point3(4,3,4))))
    assert(!(envelope3.contains?(point3(2,1,4))))
    assert(!(envelope3.contains?(point3(2,5,4))))
    assert(!(envelope3.contains?(point3(2,3,2))))
    assert(!(envelope3.contains?(point3(2,3,6))))
    assert(envelope3.contains?(envelope3))
    assert(envelope3.contains?(Envelope3.new(1.5,2.5,3.5).add(2.5,3.5,4.5)))
    assert(!(envelope3.contains? Envelope3.new(0.5,2.5,3.5).add(2.5,3.5,4.5)))
    assert(!(envelope3.contains? Envelope3.new(1.5,1.5,3.5).add(2.5,3.5,4.5)))
    assert(!(envelope3.contains? Envelope3.new(1.5,2.5,2.5).add(2.5,3.5,4.5)))
    assert(!(envelope3.contains? Envelope3.new(1.5,2.5,3.5).add(3.5,3.5,4.5)))
    assert(!(envelope3.contains? Envelope3.new(1.5,2.5,3.5).add(2.5,4.5,4.5)))
    assert(!(envelope3.contains? Envelope3.new(1.5,2.5,3.5).add(2.5,3.5,5.5)))
    assert_raise(EnvelopeException) { envelope3.contains? "bad" }
  end

end
