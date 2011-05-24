require 'test/unit'

require 'eymiha/math3/point3c'

include Eymiha
include Eymiha::ThreeDimensions
  
class TC_Point3c < Test::Unit::TestCase
  
  def test_initialize_and_equality
    p3c = Point3c.new
    assert((p3c.c_radius == 0)&&(p3c.theta == 0)&&(p3c.z == 0))
    p3c = Point3c.new 1,2,3
    assert((p3c.c_radius == 1)&&(p3c.theta == 2)&&(p3c.z == 3))
    p3a = Point3c.new 1,2,3
    assert(p3c == p3a)
    assert(p3c =~ p3a)
    assert(p3c.approximately_equals?((point3c 1.005, 1.991, 3),0.01))
    p3a = Point3c.new 3,2,1
    assert(p3c != p3a)
  end
  
  def test_Object_point3c
    p3c = point3c
    assert(p3c == origin)
    p3c = point3c 1,2,3
    assert((p3c.c_radius == 1)&&(p3c.theta == 2)&&(p3c.z == 3))
    p3a = Point3c.new 1,2,3
    assert((p3a.c_radius == 1)&&(p3a.theta == 2)&&(p3a.z == 3))
    assert(p3c == p3a)
  end
  
  def test_accessors
    p3c = point3c
    assert(p3c.point3c_like?)
    assert((p3c.c_radius == 0)&&(p3c.theta == 0)&&(p3c.z == 0))
    p3c.c_radius = 1
    p3c.theta = 2
    p3c.z = 3
    assert((p3c.c_radius == 1)&&(p3c.theta == 2)&&(p3c.z == 3))
    p3c.c_radius, p3c.theta, p3c.z =  2, 4, 6
    assert((p3c.c_radius == 2)&&(p3c.theta == 4)&&(p3c.z == 6))
  end
  
   def test_origin
     p3c = point3c 0, 0, 0
     assert(p3c == origin)
     assert(origin == p3c)
     p3c = point3c 0, 1, 0
     assert(p3c == origin)
     assert(origin == p3c)
  end
  
  def test_set
    p3c = point3c
    p3c.set 1, 2, 3
    assert((p3c.c_radius == 1)&&(p3c.theta == 2)&&(p3c.z == 3))
    p3a = point3c p3c
    assert((p3a.c_radius == 1)&&(p3a.theta == 2)&&(p3a.z == 3))
    p3b = point3c
    assert_raise(TypeError) { p3b.set "bad" }
    assert_raise(TypeError) { point3c "bad" }
  end

  def test_copy
    p3c = point3c 1, 2, 3
    p3a = p3c.point3c
    assert(p3c == p3a)
  end
  
  def test_cartesian_and_spherical
    p3c = point3c 1, 2, 3
    assert(p3c.x =~ -0.416146836547142)
    assert(p3c.y =~ 0.909297426825682)
    assert(p3c.s_radius =~ 3.16227766016838)
    assert(p3c.phi =~ 0.321750554396642)
  end
 
  def test_point3
    p3c = point3c 1, 2, 3
    p3 = p3c.point3
    assert(p3.x =~ -0.416146836547142)
    assert(p3.y =~ 0.909297426825682)
    assert(p3.z =~ 3)
    p3a = p3.point3c
    assert(p3c =~ p3a)
  end

  def test_point3s
    p3c = point3c 1, 2, 3
    p3s = p3c.point3s
    assert(p3s.s_radius =~ 3.16227766016838)
    assert(p3s.theta =~ p3c.theta)
    assert(p3s.phi =~ 0.321750554396642)
    p3a = p3s.point3c
    assert(p3c =~ p3a)
  end

end
