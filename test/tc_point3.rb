require 'test/unit'

require 'eymiha/math3/point3'

include Eymiha
include Eymiha::ThreeDimensions
  
class TC_Point3 < Test::Unit::TestCase
  
  def test_initialize_and_equality
    p3 = Point3.new
    assert(p3 == origin)
    p3 = Point3.new 1,2,3
    assert((p3.x == 1)&&(p3.y == 2)&&(p3.z == 3))
    p3a = Point3.new 1,2,3
    assert(p3 == p3a)
    p3a = Point3.new 3,2,1
    assert(p3 != p3a)
  end
  
  def test_Object_point3
    p3 = point3
    assert(p3 == origin)
    p3 = point3 1,2,3
    assert((p3.x == 1)&&(p3.y == 2)&&(p3.z == 3))
    p3a = Point3.new 1,2,3
    assert((p3a.x == 1)&&(p3a.y == 2)&&(p3a.z == 3))
    assert(p3 == p3a)
  end
  
  def test_accessors
    p3 = point3
    assert(p3.point3_like?)
    assert((p3.x == 0)&&(p3.y == 0)&&(p3.z == 0))
    p3.x = 1
    p3.y = 2
    p3.z = 3
    assert((p3.x == 1)&&(p3.y == 2)&&(p3.z == 3))
    p3.x, p3.y, p3.z = 2, 4, 6
    assert((p3.x == 2)&&(p3.y == 4)&&(p3.z == 6))
  end
  
  def test_origin
    p3 = origin
    assert((p3.x == 0)&&(p3.y == 0)&&(p3.z == 0))
  end
  
  def test_set
    p3 = point3
    p3.set 1, 2, 3
    assert((p3.x == 1)&&(p3.y == 2)&&(p3.z == 3))
    p3a = point3 p3
    assert((p3a.x == 1)&&(p3a.y == 2)&&(p3a.z == 3))
    p3b = point3
    assert_raise(TypeError) { p3b.set "bad" }
    assert_raise(TypeError) { point3 "bad" }
  end

  def test_copy
    p3 = point3 1, 2, 3
    p3a = p3.point3
    assert(p3 == p3a)
  end
  
  def test_spherical_and_cylindrical
    p3 = point3 1, 2, 3
    assert(p3.s_radius =~ 3.74165738677394)
    assert(p3.c_radius =~ 2.23606797749979)
    assert(p3.theta =~ 1.10714871779409)
    assert(p3.phi =~ 0.640522312679425)
  end
  
  def test_distance_to
    p3a = point3 1, 2, 3
    p3b = point3 5, -3, 4
    assert(p3a.distance_to(p3b) =~ 6.48074069840786)
  end
  
  def test_modulus
    p3 = point3
    assert(p3.modulus == 0)
    p3.set 1, 2, 3
    assert(p3.modulus =~ 3.74165738677394)
  end
  
  def test_dot
    p3a = point3 1, 2, 3
    p3b = point3 5, -3, 4
    assert(p3a.dot(p3b) =~ 11)
  end
  
  def test_mirrors
    p3a = point3 1, 2, 3
    p3b = point3(-1, -2, -3)
    assert(p3a.mirror == p3b)
    p3a.mirror!
    assert(p3a == p3b)
  end

  def test_adds
    p3a = point3 1, 2, 3
    p3d = point3 p3a
    assert(p3a.add == p3d)
    p3a.add!
    assert(p3a == p3d)
    p3b = point3 5, -3, 4
    p3c = point3 6, -1, 7
    assert(p3a.add(p3b) == p3c)
    assert(p3a.add(p3b.x,p3b.y,p3b.z) == p3c)
    assert(p3a+p3b == p3c)
    p3a.add! p3b
    assert(p3a == p3c)
    p3d.add!(p3b.x,p3b.y,p3b.z)
    assert(p3d == p3c)
  end

  def test_subtracts
    p3a = point3 1, 2, 3
    p3d = point3 p3a
    assert(p3a.subtract == p3d)
    p3a.subtract!
    assert(p3a == p3d)
    p3b = point3 5, -3, 4
    p3c = point3(-4, 5, -1)
    assert(p3a.subtract(p3b) == p3c)
    assert(p3a.subtract(p3b.x,p3b.y,p3b.z) == p3c)
    assert(p3a-p3b == p3c)
    p3a.subtract! p3b
    assert(p3a == p3c)
    p3d.subtract!(p3b.x,p3b.y,p3b.z)
    assert(p3d == p3c)
  end

  def test_multiplies
    p3a = point3 1, 2, 3
    p3d = point3 p3a
    assert(p3a.multiply == p3d)
    p3a.multiply!
    assert(p3a == p3d)
    p3b = point3 5, -3, 4
    p3c = point3 5, -6, 12
    assert(p3a.multiply(p3b) == p3c)
    assert(p3a.multiply(p3b.x,p3b.y,p3b.z) == p3c)
    assert(p3a*p3b == p3c)
    p3a.multiply! p3b
    assert(p3a == p3c)
    p3d.multiply!(p3b.x,p3b.y,p3b.z)
    assert(p3d == p3c)
  end
  
  def test_scales
    p3a = point3 1, 2, 3
    p3d = point3 p3a
    assert(p3a.scale == p3d)
    p3a.scale!
    assert(p3a == p3d)
    p3b = point3 3, 6, 9
    p3c = point3 3, 12, 27
    assert(p3a.scale(3) == p3b)
    assert(p3a.scale(p3b) == p3c)
    p3a.scale! 3
    assert(p3a == p3b)
    p3d.scale! p3b
    assert(p3d == p3c)
  end
  
  def test_units_and_approximately_equals
    p3a = point3 1, 2, 3
    p3b = point3 0.267261241912424, 0.534522483824849, 0.801783725737273
    assert(p3a.unit =~ p3b)
    p3a.unit!
    assert(p3a =~ p3b)
    p3a = point3 1, 2, 3
    p3b = point3 0.2672, 0.5345, 0.8017
    assert(p3a.unit.approximately_equals?(p3b,0.0001))
    p3a.unit!
    assert(p3a.approximately_equals?(p3b,0.0001))
  end

  def test_cross
    p3a = point3 1, 2, 3
    p3b = point3 2, 4, 6
    assert(p3a.cross(p3b) == origin)
    p3b.cross! p3a
    assert(p3b == origin)
    p3c = point3 3, 2, 1
    p3d = point3(-4, 8, -4)
    assert(p3a.cross(p3c) == p3d)
    p3a.cross! p3c
    assert(p3a == p3d)
  end
  
  def test_to_along
    p3a = point3 1, 2, 3
    p3b = point3(-10, 3, 4)
    p3c = p3a.to_along p3b, 0
    assert(p3c =~ p3a)
    p3c = p3a.to_along p3b, 1
    assert(p3c =~ p3b)
  end
  
  def test_point3s
    p3a = point3 1, 2, 3
    p3s = p3a.point3s
    assert(p3s.s_radius =~ 3.74165738677394)
    assert(p3s.theta =~ 1.10714871779409)
    assert(p3s.phi =~ 0.640522312679425)
    p3b = p3s.point3
    assert(p3a =~ p3b)
  end

  def test_point3c
    p3a = point3 1, 2, 3
    p3c = p3a.point3c
    assert(p3c.c_radius =~ 2.23606797749979)
    assert(p3c.theta =~ 1.10714871779409)
    assert(p3c.z =~ 3)
    p3b = p3c.point3
    assert(p3a =~ p3b)
  end

end
