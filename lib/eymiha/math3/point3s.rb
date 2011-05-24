require 'eymiha/math3'

module Eymiha

  # Point3s represents a 3D point in spherical coordinates:
  # * s_radius is the distance from the origin.
  # * theta is the angular distance around the cylindrical axis.
  # * phi is angle that rotates the cylindrical axis to be directed at the point.
  # The spherical theta coordinate is equal to the cylindrical theta.
  #
  # From a cartesian reference, the cylindrical axis is the z axis, theta is
  # measured using the right hand rule with the positive x axis representing 0,
  # and the phi is an angle measured from the positive z axis.
  #
  # Point3s instances may be converted to Point3 and Point3c instances, but
  # information at the "boundaries" may be lost. Besides responding as a Point3s,
  # an instance will also respond like a Point3 and Point3c as it has a full 
  # complement of readers for the different coordinate systems.
  class Point3s
    
    include ThreeDimensions
    
    # spherical radius coordinate reader and writer.
    attr_accessor :s_radius
    # spherical theta coordinate reader.
    attr_reader :theta
    # spherical phi coordinate reader.
    attr_reader :phi
    
    # spherical coordinate theta writer, rectifying theta to a value in
    # [0, 2*pi).
    def theta=(theta)
      @theta = theta.rectify_theta
    end
    
    # spherical coordinate theta writer, rectifying theta to a value in
    # [0, pi].
    def phi=(phi)
      @phi = phi.rectify_phi
    end
    
    # Creates and returns a Point3s instance. Sets the coordinates values using
    # the set method.
    def initialize(s_radius=0, theta=0, phi=0)
      set s_radius, theta, phi
    end
    
    # Returns a string representation of the instance.
    def to_s
      "Point3s: s_radius #{s_radius}  theta #{theta}  phi #{phi}"
    end
    
    # Returns a string representation of the instance.
    # Sets the coordinate values of the instance. When
    # * s_radius is Numeric, the arguments are interpretted as coordinates.
    # * s_radius responds like a Point3c, its spherical coordinates are assigned.
    # * otherwise a TypeError is raised.
    # The modified instance is returned.
    def set(s_radius=0, theta=0, phi=0)
      if s_radius.kind_of? Numeric
        @s_radius, @theta, @phi =
          1.0*s_radius, (1.0*theta).rectify_theta, (1.0*phi).rectify_phi
      elsif s_radius.point3s_like?
        set s_radius.s_radius, s_radius.theta, s_radius.phi
      else
        raise_no_conversion s_radius
      end
      self
    end
    
    # Returns true if the coordinates of the instance are effectively equal to the
    # coordinates of the given point.
    def ==(point3s)
      (point3s.s_radius == s_radius) &&
        ((s_radius == 0) || ((point3s.theta == theta) && (point3s.phi == phi)))
    end
    
    # Returns true if the coordinates of the instance are approximately
    # effectively equal to the coordinates of the given point, each coordinate
    # less than a distance epsilon from the target.
    def approximately_equals?(point3s,epsilon=Numeric.epsilon)
      (@s_radius.approximately_equals?(point3s.s_radius,epsilon)&&
       ((@s_radius.approximately_equals?(0,epsilon) ||
         (@theta.approximately_equals?(point3s.theta,epsilon)&&
          @phi.approximately_equals?(point3s.phi,epsilon)))))
    end
    
    alias =~ approximately_equals?
    
    # Returns a 3D point in cartesian coordinates, filling point3 if given,
    # and copied from point3s.
    def point3(point3=nil, point3s=self)
      (point3 ||= Point3.new).set(point3s.x,point3s.y,point3s.z)
    end
    
    # Returns a copy of point3s with the given spherical coordinates:
    # * s_radius is Numeric, the arguments are copied as the coordinates.
    # * s_radius responds like a Point3c, its coordinates are copied.
    # * otherwise a TypeError is raised.
    def point3s(s_radius=self.s_radius,theta=self.theta,phi=self.phi)
      Point3s.new(s_radius,theta,phi)
    end
    
    # Returns a 3D point in cartesian coordinates, filling point3 if given,
    # and copied from point3s.
    def point3c(point3c=nil,point3s=self)
      (point3c ||= Point3c.new).set(point3s.c_radius,point3s.theta,point3s.z)
    end
    
    # Returns the cartesian x coordinate of the instance.
    def x
      s_radius*Math.cos(theta)*Math.sin(phi)
    end
    
    # Returns the cartesian y coordinate of the instance.
    def y
      s_radius*Math.sin(theta)*Math.sin(phi)
    end
    
    # Returns the cartesian z coordinate of the instance.
    def z
      s_radius*Math.cos(phi);
    end
    
    # Returns the cylindrical radius coordinate of the instance.
    def c_radius
      s_radius*Math.sin(phi)
    end
    
  end

end
