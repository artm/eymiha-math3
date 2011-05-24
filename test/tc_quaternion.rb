require 'test/unit'

require 'eymiha/math3/quaternion'

include Eymiha
include Eymiha::ThreeDimensions
  
class TC_Quaternion < Test::Unit::TestCase
  
  def test_initialize_and_equality
    q = Quaternion.new
    assert((q.axis == origin)&&(q.real == 0))
    qa = Quaternion.new(origin,0)
    assert(q == qa)
    p3 = point3 1,2,3
    qb = Quaternion.new p3,4
    assert(qb.axis == p3)
    assert(qb.real == 4)
    assert(q != qb)
    qc = quaternion p3,4
    assert(qc.axis == p3)
    assert(qc.real == 4)
    assert(q != qb)
    assert(qb == qc)
  end

  def test_accessors
    p3 = point3 1,2,3
    q = quaternion p3,4
    q.axis.scale! 2
    q.real -= 3
    assert(q.axis == point3(2,4,6))
    assert(q.real == 1)
    qb = quaternion q
    assert(q == qb)
  end

  def test_axis_angle
    p3 = point3 1,2,3
    q = Quaternion.from_axis_angle(p3,pi/8)
    assert(q.axis.x =~ 0.195090322016128)
    assert(q.axis.y =~ 0.390180644032256)
    assert(q.axis.z =~ 0.585270966048385)
    assert(q.real =~ 0.98078528040323)
    qb = q.to_axis_angle
    assert(qb.axis =~ p3)
    assert(qb.real =~ pi/8)
  end

  def test_add
    p3a,ra = point3(1,2,3),4
    p3b,rb = point3(4,-6,0),-3
    qa = quaternion p3a,ra
    qb = quaternion p3b,rb
    p3c,rc = p3a+p3b,ra+rb
    qc = qa+qb
    assert(qc.axis =~ p3c)
    assert(qc.real =~ rc)
    qa.add! qb
    assert(qa =~ qc)
  end

  def test_subtract
    p3a,ra = point3(1,2,3),4
    p3b,rb = point3(4,-6,0),-3
    qa = quaternion p3a,ra
    qb = quaternion p3b,rb
    p3c,rc = p3a-p3b,ra-rb
    qc = qa-qb
    assert(qc.axis =~ p3c)
    assert(qc.real =~ rc)
    qa.subtract! qb
    assert(qa =~ qc)
  end

  def test_multiply
    p3a,ra = point3(1,2,3),4
    p3b,rb = point3(4,-6,0),-3
    qa = quaternion p3a,ra
    qb = quaternion p3b,rb
    p3c,rc = point3(-1,30,-23),-4
    qc = qa*qb
    assert(qc.axis =~ p3c)
    assert(qc.real =~ rc)
    qa.multiply! qb
    assert(qa =~ qc)
  end

  def test_scale
    p3a,ra = point3(1,2,3),4
    qa = quaternion p3a,ra
    p3c,rc = p3a.scale(5.5),ra*5.5
    qc = qa.scale(5.5)
    assert(qc.axis =~ p3c)
    assert(qc.real =~ rc)
    qa.scale! 5.5
    assert(qa =~ qc)
  end

  def test_conjugate
    p3a,ra = point3(1,2,3),4
    qa = quaternion p3a,ra
    p3c,rc = point3(-1,-2,-3),ra
    qc = qa.conjugate
    assert(qc.axis =~ p3c)
    assert(qc.real =~ rc)
    qa.conjugate!
    assert(qa =~ qc)
  end

  def test_norm
    p3a,ra = point3(1,2,3),4
    qa = quaternion p3a,ra
    assert(qa.norm =~ 19.7416573867739)
  end

  def test_abs
    p3a,ra = point3(1,2,3),4
    qa = quaternion p3a,ra
    assert(qa.abs =~ 4.44315849219606)
  end

  def test_inverse
    p3a,ra = point3(1,2,3),4
    qa = quaternion p3a,ra
    q = qa.inverse
    assert(q.axis.x =~ (-0.0506543083191159))
    assert(q.axis.y =~ (-0.101308616638232))
    assert(q.axis.z =~ (-0.151962924957348))
    assert(q.real =~ 0.202617233276464)
    qa.inverse!
    assert(q =~ qa)
  end

  def test_divide
    p3a,ra = point3(1,2,3),4
    qa = quaternion p3a,ra
    p3b,rb = point3(10,0,-10),0
    qb = quaternion p3b,rb
    qc = qa.divide qb
    assert(qc.axis.x =~ 2.41421356237309)
    assert(qc.axis.y =~ (-2.82842712474619))
    assert(qc.axis.z =~ 0.414213562373095)
    assert(qc.real =~ -1.41421356237309)
    qa.divide! qb
    assert(qa =~ qc)
  end

end
