require 'eymiha/math3'

module Eymiha

  # Point3 represents a 3D point in cartesian coordinates:
  # * x is the signed distance from the 3D origin along the x axis.
  # * y is the signed distance from the 3D origin along the y axis.
  # * z is the signed distance from the 3D origin along the z axis.
  # The cylindrical z coordinate is equal to the cartesian z coordinate.
  #
  # Point3 instances may be converted to Point3s and Point3c instances, but
  # information at the "boundaries" may be lost. Besides responding as a Point3,
  # an instance will also respond like a Point3s and Point3c as it has a full 
  # complement of readers for the different coordinate systems.
  class Point3
    
    include ThreeDimensions
    
    # x coordinate reader and writer.
    attr_accessor :x
    # y coordinate reader and writer.
    attr_accessor :y
    # z coordinate reader and writer.
    attr_accessor :z
    
    # Returns the origin of 3D space, where x, y, and z all have zero values.
    def Point3.origin
      @@origin3
    end
    
    # Creates and returns a Point3 instance. Sets the coordinates values using
    # the set method.
    def initialize(x=0, y=0, z=0)
      set x, y, z
    end
    
    # Returns a string representation of the instance.
    def to_s
      "Point3: x #{x}  y #{y}  z #{z}"
    end
    
    # Sets the coordinate values of the instance. When
    # * x is Numeric, the arguments are interpretted as coordinates.
    # * x responds like a Point3, its cartesian coordinates are assigned.
    # * otherwise a TypeError is raised.
    # The modified instance is returned.
    def set(x=0, y=0, z=0)
      if x.kind_of? Numeric
        @x, @y, @z = 1.0*x, 1.0*y, 1.0*z
      elsif x.point3_like?
        set x.x, x.y, x.z
      else
        raise_no_conversion x
      end
      self
    end
    
    # Returns true if the coordinates of the instance are equal to the
    # coordinates of the given point.
    def ==(point3)
      (@x == point3.x)&&(@y == point3.y)&&(@z == point3.z)
    end
    
    # Returns true if the coordinates of the instance are approximately equal
    # to the coordinates of the given point, each coordinate less than a distance
    # epsilon from the target.
    def approximately_equals?(point3,epsilon=Numeric.epsilon)
      @x.approximately_equals?(point3.x,epsilon)&&
        @y.approximately_equals?(point3.y,epsilon)&&
        @z.approximately_equals?(point3.z,epsilon)
    end
    
    alias =~ approximately_equals?
    
    # Returns a copy of point3 with the given cartesian coordinates:
    # * x is Numeric, the arguments are copied as the coordinates.
    # * x responds like a Point3, its coordinates are copied.
    # * otherwise a TypeError is raised.
    def point3(x=self.x,y=self.y,z=self.z)
      Point3.new(x,y,z)
    end
    
    # Returns a 3D point in spherical coordinates, filling point3s if given,
    # and copied from point3.
    def point3s(point3s=nil,point3=self)
      (point3s ||= Point3s.new).set(point3.s_radius,point3.theta,point3.phi)
    end
    
    # Returns a 3D point in cylindrical coordinates, filling point3c if given,
    # and copied from point3. 
    def point3c(point3c=nil,point3=self)
      (point3c ||= Point3c.new).set(point3.c_radius,point3.theta,point3.z)
    end
    
    # Returns the spherical radius coordinate of the instance.
    def s_radius
      modulus
    end
    
    # Returns the cylindrical radius coordinate of the instance.
    def c_radius   
      Math.sqrt((@x*@x)+(@y*@y))
    end
    
    # Returns the spherical/cylindrical theta coordinate of the instance.
    def theta
      (@x == 0)? ((@y > 0)? @@pio2 : -@@pio2) : Math.atan2(@y,@x)
    end
    
    # Returns the spherical phi coordinate of the instance.
    def phi
      m = modulus
      (m == 0)? 0 : Math.acos(z/m)
    end
    
    # Returns the 3D distance from the instance to point3.
    def distance_to(point3)
      Math.sqrt(((@x-point3.x)**2)+((@y-point3.y)**2)+((@z-point3.z)**2))
    end
    
    # Returns the 3D distance from the instance to the origin.
    def modulus
      distance_to(origin)
    end
    
    # Returns the dot product of the vectors represented by the instance and
    # point3, with common endpoints at the origin.
    def dot(point3)
      (@x*point3.x)+(@y*point3.y)+(@z*point3.z)
    end
    
    # Returns a new Point3 instance whose coordinates are the original
    # instance's mirrored through the origin.
    def mirror
      point3.mirror!
    end
    
    # Returns the modified instance whose coordinates have been mirrored through
    # the origin.
    def mirror!
      set(-@x, -@y, -@z)
    end
    
    # Returns a new Point3 instance whose coordinates are the original
    # instance's with the given amounts added:
    # * x is Numeric, the arguments are added to the coordinates.
    # * x responds like a Point3, its cartesian coordinates are added.
    # * otherwise a TypeError is raised.
    def add(x=0,y=0,z=0)
      point3.add!(x,y,z)
    end
    
    alias + add
    
    # Returns the modified instance with the arguments added.
    def add!(x=0,y=0,z=0)
      if x.kind_of? Numeric
        set(@x+x, @y+y, @z+z)
      elsif x.point3_like?
        add! x.x, x.y, x.z
      else
        raise_no_conversion x
      end
    end
    
    # Returns a new Point3 instance whose coordinates are the original
    # instance's with the given amounts subtracted:
    # * x is Numeric, the arguments are subtracted from the coordinates.
    # * x responds like a Point3, its cartesian coordinates are subtracted.
    # * otherwise a TypeError is raised.
    def subtract(x=0,y=0,z=0)
      point3.subtract!(x,y,z)
    end
    
    alias - subtract
    
    # Returns the modified instance with the arguments subtracted.
    def subtract!(x=0,y=0,z=0)
      if x.kind_of? Numeric
        add!(-x, -y, -z)
      elsif x.point3_like?
        subtract! x.x, x.y, x.z
      else
        raise_no_conversion x
      end
    end
    
    # Returns a new Point3 instance whose coordinates are the original
    # instance's multiplied by the given amounts:
    # * x is Numeric, the coordinates are multiplied by the arguments.
    # * x responds like a Point3, the instance's coordinates are multiplied by x's coordinates.
    # * otherwise a TypeError is raised.
    def multiply(x=1,y=1,z=1)
      point3.multiply!(x,y,z)
    end
    
    alias * multiply
    
    # Returns the modified instance as multiplied by the arguments.
    def multiply!(x=1,y=1,z=1)
      if x.kind_of? Numeric
        set(@x*x, @y*y, @z*z)
      elsif x.point3_like?
        multiply! x.x, x.y, x.z
      else
        raise_no_conversion x
      end
    end
    
    # Returns a new Point3 instance whose coordinates are the original
    # instance's multiplied by the scalar.
    # * scalar is Numeric, the arguments are multiplied by the coordinates.
    # * x responds like a Point3, the instance is multiplied by the scalar.
    # * otherwise a TypeError is raised.
    def scale(scalar=1)
      point3.scale!(scalar)
    end
    
    # Returns the modified instance as multiplied by the scalar.
    def scale!(scalar=1)
      if scalar.kind_of? Numeric
        multiply! scalar, scalar, scalar
      elsif scalar.point3_like?
        multiply! scalar
      else
        raise_no_conversion scalar
      end
    end
    
    # Returns a new Point3 instance representing the unit vector (with the same
    # direction as the original instance, but whose length is 1.)
    def unit(x=1,y=1,z=1)
      point3.unit!
    end
    
    # Returns the modified instance as the unit vector.
    def unit!(x=1,y=1,z=1)
      scale!(1/modulus)
    end
    
    # Returns a new Point3 instance that is the cross product of the given
    # arguments treated as vectors with endpoints at the origin:
    # * x is Numeric, the cross product of the instance with the arguments.
    # * x responds like a Point3,
    #   * y is Numeric, the cross product of the instance with x's coordinates.
    #   * y responds like a Point3, the cross product of x with y.
    # * otherwise a TypeError is raised.
    def cross(x=1/sqrt3,y=1/sqrt3,z=1/sqrt3)
      point3.cross!(x,y,z)
    end
    
    # Returns the modified instance as the cross product.
    def cross!(x=1/sqrt3,y=1/sqrt3,z=1/sqrt3)
      if x.kind_of? Numeric
        set((@y*z)-(@z*y), (@z*x)-(@x*z), (@x*y)-(@y*x))
      elsif x.point3_like?
        if y.kind_of? Numeric
          cross! x.x, x.y, x.z
        elsif y.point3_like?
          set(x).cross!(y)
        else
          raise_no_conversion y
        end
      else
        raise_no_conversion x
      end
    end
    
    # Returns a new Point3 that is a distance d from the instance along the
    # line to the Point3 e. If normalized is true, the d argument specifies
    # the fraction of the distance from the instance (being 0) to e (being 1).
    #If normalize is false, the d argument specifies an absolute distance.
    def to_along (e, d, normalize=true)
      scalar = normalize ? (distance_to e) : 1
      point3(e).subtract!(self).unit!.scale!(d*scalar).add(self)
    end
    
    # The 3D origin
    @@origin3 = Point3.new
    
  end

end
