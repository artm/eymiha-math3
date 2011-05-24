require 'eymiha/math3'

module Eymiha

  # Point3c represents a 3D point in cylindrical coordinates:
  # * c_radius is the distance from the cylindrical axis.
  # * theta is the angular distance around the cylindrical axis.
  # * z is the distance from the cylindrical base-plane.
  # The cylindrical theta coordinate is equal to the spherical theta. The
  # cylindrical z coordinate is equal to the cartesian z coordinate.
  #
  # From a cartesian reference, the cylindrical axis is the z axis, theta is
  # measured using the right hand rule with the positive x axis representing 0,
  # and the cylindrical plane is the plane z=0.
  #
  # Point3c instances may be converted to Point3 and Point3s instances, but
  # information at the "boundaries" may be lost. Besides responding as a Point3c,
  # an instance will also respond like a Point3 and Point3s as it has a full 
  # complement of readers for the different coordinate systems.
  class Point3c
    
    include ThreeDimensions
    
    # cylindrical radius coordinate reader and writer.
    attr_accessor :c_radius
    # cylindrical z coordinate reader and writer.
    attr_accessor :z
    # cylindrical theta reader.
    attr_reader :theta
    
    # cylindrical theta coordinate writer, rectifying theta to a value in
    # [0, 2*pi).
    def theta=(theta)
      @theta = theta.rectify_theta
    end
    
    # Creates and returns a Point3c instance. Sets the coordinates values using
    # the set method.
    def initialize(c_radius=0, theta=0, z=0)
      set c_radius, theta, z
    end
    
    # Returns a string representation of the instance.
    def to_s
      "Point3c: c_radius #{c_radius}  theta #{theta}  z #{z}"
    end
    
    # Sets the coordinate values of the instance. When
    # * c_radius is Numeric, the arguments are interpretted as coordinates.
    # * c_radius responds like a Point3c, its cylindrical coordinates are assigned.
    # * otherwise a TypeError is raised.
    # The modified instance is returned.
    def set(c_radius=0, theta=0, z=0)
      if c_radius.kind_of? Numeric
        @c_radius, @theta, @z = 1.0*c_radius, (1.0*theta).rectify_theta, 1.0*z
      elsif c_radius.point3c_like?
        set c_radius.c_radius, c_radius.theta, c_radius.z
      else
        raise_no_conversion c_radius
      end
      self
    end
    
    # Returns true if the coordinates of the instance are effectively equal to the
    # coordinates of the given point.
    def ==(point3c)
      ((point3c.c_radius == c_radius) && (point3c.z == z)) &&
        (((c_radius == 0) && (z == 0)) || (point3c.theta == theta))
    end
    
    # Returns true if the coordinates of the instance are approximately
    # effectively equal to the coordinates of the given point, each coordinate
    # less than a distance epsilon from the target.
    def approximately_equals?(point3c,epsilon=Numeric.epsilon)
      (@c_radius.approximately_equals?(point3c.c_radius,epsilon) &&
       @z.approximately_equals?(point3c.z,epsilon)) &&
        ((@c_radius.approximately_equals?(0,epsilon) &&
          @z.approximately_equals?(0,epsilon)) ||
         @theta.approximately_equals?(point3c.theta,epsilon))
    end
    
    alias =~ approximately_equals?
    
    # Returns a 3D point in cartesian coordinates, filling point3 if given,
    # and copied from point3c.
    def point3(point3=nil,point3c=self)
      (point3 ||= Point3.new).set(point3c.x,point3c.y,point3c.z)
    end
    
    # Returns a 3D point in spherical coordinates, filling point3s if given,
    # and copied from point3c.
    def point3s(point3s=nil,point3c=self)
      (point3s ||= Point3s.new).set(point3c.s_radius,point3c.theta,point3c.phi)
    end
    
    # Returns a copy of point3c with the given cylindrical coordinates:
    # * c_radius is Numeric, the arguments are copied as the coordinates.
    # * c_radius responds like a Point3c, its coordinates are copied.
    # * otherwise a TypeError is raised.
    def point3c(c_radius=self.c_radius,theta=self.theta,z=self.z)
      Point3c.new(c_radius,theta,z)
    end
    
    # Returns the cartesian x coordinate of the instance.
    def x
      c_radius*Math.cos(theta)
    end
    
    # Returns the cartesian y coordinate of the instance.
    def y
      c_radius*Math.sin(theta)
    end
    
    # Returns the spherical radius coordinate of the instance.
    def s_radius
      Math.sqrt((x**2)+(y**2)+(z**2))
    end
    
    # Returns the spherical phi coordinate of the instance.
    def phi
      m = s_radius
      (m == 0)? 0 : Math.acos(z/m)
    end
    
  end

end
