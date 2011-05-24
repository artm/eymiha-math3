require 'eymiha'
require 'eymiha/math'

# These modifications to objects add 3D point duck classifying.
class Object
  
  # Returns true if the instance has 3D cartesian coordinates, ie. responds 
  # to x, y and z.
  def point3_like?
    (respond_to? :x)&&(respond_to? :y)&&(respond_to? :z)
  end
  
  # Returns true if the instance has 3D spherical coordinates, ie. responds
  # to s_radius, theta and phi.
  def point3s_like?
    (respond_to? :s_radius)&&(respond_to? :theta)&&(respond_to? :phi)
  end
  
  # Returns true if the instance has 3D cylindrical coordinates, ie responds
  # to c_radius, theta and z.
  def point3c_like?
    (respond_to? :c_radius)&&(respond_to? :theta)&&(respond_to? :z)
  end

end

# The ThreeDimensions module adds shorthands for common 3D entities, mostly to
# improve code readability.
module Eymiha
  module ThreeDimensions
  
    # shorthand for 2*pi.
    def two_pi
      2.0*Math::PI
    end
    
    # shorthand for pi.
    def pi
      Math::PI
    end
    
    # shorthand for pi/2.
    def half_pi
      Math::PI/2.0
    end
    
    # shorthand for the square root of 2.
    def sqrt2
      Math.sqrt 2
    end
    
    # shorthand for the square root of 3.
    def sqrt3
      Math.sqrt 3
    end
    
    # the origin of 3D space.
    def origin
      Point3.origin
    end
    
    # shorthand for creating a 3D point in cartesian coordinates.
    def point3(x=0, y=0, z=0)
      Point3.new(x,y,z)
    end
    
    # shorthand for creating a 3D point in spherical coordinates.
    def point3s(s_radius=0, theta=0, phi=0)
      Point3s.new(s_radius,theta,phi)
    end
    
    # shorthand for creating a 3D point in cylindrical coordinates.
    def point3c(c_radius=0, theta=0, z=0)
      Point3c.new(c_radius,theta,z)
    end
    
    # shorthand for creating a quaternion.
    def quaternion(axis=origin,real=0)
      Quaternion.new(axis,real)
    end
    
  end
end


class Numeric
  
  include Eymiha::ThreeDimensions
  
  # Returns the instance's value folded to lie between [0, 2*pi).
  def rectify_theta
    wrap_rectify two_pi
  end
  
  # Returns the instance's value cut to lie between [0, pi].
  def rectify_phi
    cut_rectify pi
  end
  
end
