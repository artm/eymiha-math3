require 'test/unit'

require 'eymiha/math3/point3s'

include Eymiha
include Eymiha::ThreeDimensions
  
class TC_Point3s < Test::Unit::TestCase
  
  def test_initialize_and_equality
    p3s = Point3s.new
    assert((p3s.s_radius == 0)&&(p3s.theta == 0)&&(p3s.phi == 0))
    p3s = Point3s.new 1,2,3
    assert((p3s.s_radius == 1)&&(p3s.theta == 2)&&(p3s.phi == 3))
    p3a = Point3s.new 1,2,3
    assert(p3s == p3a)
    assert(p3s =~ p3a)
    assert(p3s.approximately_equals?((point3s 1.005, 1.991, 3),0.01))
    p3a = Point3s.new 3,2,1
    assert(p3s != p3a)
  end
  
  def test_Object_point3s
    p3s = point3s
    assert(p3s == origin)
    p3s = point3s 1,2,3
    assert((p3s.s_radius == 1)&&(p3s.theta == 2)&&(p3s.phi == 3))
    p3a = Point3s.new 1,2,3
    assert((p3a.s_radius == 1)&&(p3a.theta == 2)&&(p3a.phi == 3))
    assert(p3s == p3a)
  end
  
  def test_accessors
    p3s = point3s
    assert(p3s.point3s_like?)
    assert((p3s.s_radius == 0)&&(p3s.theta == 0)&&(p3s.phi == 0))
    p3s.s_radius = 1
    p3s.theta = 2
    p3s.phi = 3
    assert((p3s.s_radius == 1)&&(p3s.theta == 2)&&(p3s.phi == 3))
    p3s.s_radius, p3s.theta, p3s.phi =  2, 4, 6
    assert((p3s.s_radius == 2)&&(p3s.theta == 4)&&(p3s.phi == pi))
    p3s.s_radius, p3s.theta, p3s.phi =  -2, -4, -6
    assert((p3s.s_radius == -2)&&(p3s.theta =~ 2.28318530717959)&&
           (p3s.phi == 0))
  end
  
   def test_origin
     p3s = point3s 0, 0, 0
     assert(p3s == origin)
     assert(origin == p3s)
     p3s = point3s 0, 1, 2
     assert(p3s == origin)
     assert(origin == p3s)
  end
  
  def test_set
    p3s = point3s
    p3s.set 1, 2, 3
    assert((p3s.s_radius == 1)&&(p3s.theta == 2)&&(p3s.phi == 3))
    p3a = point3s p3s
    assert((p3a.s_radius == 1)&&(p3a.theta == 2)&&(p3a.phi == 3))
    p3b = point3s
    assert_raise(TypeError) { p3b.set "bad" }
    assert_raise(TypeError) { point3s "bad" }
  end

  def test_copy
    p3s = point3s 1, 2, 3
    p3a = p3s.point3s
    assert(p3s == p3a)
  end
  
  def test_cartesian_and_cylindrical
    p3s = point3s 1, 2, 3
    assert(p3s.x =~ -0.058726644927621)
    assert(p3s.y =~ 0.128320060202457)
    assert(p3s.z =~ -0.989992496600445)
    assert(p3s.c_radius =~ 0.141120008059867)
  end
 
  def test_point3
    p3s = point3s 1, 2, 3
    p3 = p3s.point3
    assert(p3.x =~ -0.058726644927621)
    assert(p3.y =~ 0.128320060202457)
    assert(p3.z =~ -0.989992496600445)
    p3a = p3.point3s
    assert(p3s =~ p3a)
  end

  def test_point3c
    p3s = point3s 1, 2, 3
    p3c = p3s.point3c
    assert(p3c.c_radius =~ 0.141120008059867)
    assert(p3c.theta =~ p3s.theta)
    assert(p3c.z =~ -0.989992496600445)
    p3a = p3c.point3s
    assert(p3s =~ p3a)
  end

end
