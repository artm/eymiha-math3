require 'eymiha/math3'

module Eymiha

  # Quaternion instances represents Quaternions, complex numbers with one real
  # part and three imaginary parts. While the math is a bit obscure, they can be
  # used to manipulate 3D rotations without "gimbal lock", the problem of
  # coincident viewing angle alignment problems at the boundaries, for example,
  # where the difference between the x and y coordinates of the viewing vector
  # are zero (ie. looking straight up or straight down.)
  #
  # Interestingly, Quaternions were first conceptualized by Hamilton in 1843,
  # well before the widespread use of vector notation. While mostly put on the
  # shelf, they still solve certain problems elegantly, and in some cases more
  # quickly than matrix-based 3D calulations.
  #
  # The quaternion's real part is accessed through the real instance variable,
  # the three complex parts as the quaternion's "axis" vector, a Point3.
  class Quaternion
    
    include ThreeDimensions
    
    # complex axis vector part reader and writer
    attr_accessor :axis
    # real part reader and writer
    attr_accessor :real
    
    # Creates and returns a Quaternion instance. Sets the coordinates values
    # using the set method.
    def initialize(axis=origin,real=0)
      set axis, real
    end
    
    # Returns a string representation of the instance.
    def to_s
      "Quaternion:  axis: x #{axis.x}  y #{axis.y} z #{axis.z}   real #{real}"
    end
    
    # Sets the axis and real values of the instance. When
    # * axis is a Quaternion, the arguments are interpretted as the parts of a quaternion.
    # * axis reponds like a Point3, the axis and real are used to set the quaternion's values.
    # * otherwise a TypeError is raised.
    # The modified instance is returned.
    def set(axis=origin,real=0)
      if axis.kind_of? Quaternion
        set axis.axis, axis.real
      elsif axis.point3_like?
        (@axis ||= point3).set(axis)
        @real = real
      else
        raise_no_conversion(self.class.name,axis)
      end
      self
    end
    
    # Returns true if the parts of the instance are equal to the
    # parts of the given quaternion.
    def ==(quaternion)
      (@axis == quaternion.axis)&&(@real == quaternion.real)
    end
    
    # Returns true if the parts of the instance are approximately
    # equal to the parts of the given quaternion, each part
    # less than a distance epsilon from the target.
    def approximately_equals?(quaternion,epsilon=Numeric.epsilon)
      (@axis.approximately_equals?(quaternion.axis,epsilon)&&
       @real.approximately_equals?(quaternion.real,epsilon))
    end
    
    alias =~ approximately_equals?
    
    # Returns a copy of a Quaternion with the given parts:
    # * axis is a Quaternion, its parts are copied.
    # * axis responds like a Point3, the arguments are copied.
    # * otherwise a TypeError is raised.
    def quaternion(axis=self.axis,real=self.real)
      Quaternion.new(axis,real)
    end
    
    # Returns a new Quaternion-based encoding of a rotation.
    def Quaternion.from_axis_angle(axis,angle)
      half_angle = angle/2.0
      Quaternion.new Point3.new(axis).scale(Math.sin(half_angle)),
      Math.cos(half_angle)
    end
    
    # Returns a new Quaternion encoded into a rotation.
    def to_axis_angle
      half_angle = Math.acos(@real)
      sin_half_angle = Math.sin(half_angle)
      axis = (sin_half_angle.abs < 0.00000001)?
      Point3.new(1,0,0) : Point3.new(@axis).scale!(1.0/sin_half_angle)
      Quaternion.new(axis,2.0*half_angle)
    end
    
    # Returns a new Quaternion instance whose parts are the original
    # instance's with the given amounts added:
    # * axis is a Quaternion, its parts are added.
    # * axis responds like a Point3, the arguments are added.
    # * otherwise a TypeError is raised.
    def add(axis=origin,real=0)
      quaternion.add!(axis,real)
    end
    
    alias + add
    
    # Returns the modified instance with the arguments added.
    def add!(axis=origin,real=0)
      if axis.kind_of? Quaternion
        add!(axis.axis,axis.real)
      elsif axis.point3_like?
        set(@axis+axis,@real+real)
      else
        raise_no_conversion axis
      end
      self
    end
    
    # Returns a new Quaternion instance whose parts are the original
    # instance's with the given amounts subtracted:
    # * axis is a Quaternion, its parts are subtracted.
    # * axis responds like a Point3, the arguments are subtracted.
    # * otherwise a TypeError is raised.
    def subtract(axis=origin,real=0)
      quaternion.subtract!(axis,real)
    end
    
    alias - subtract
    
    # Returns the modified instance with the arguments subtracted.
    def subtract!(axis=origin,real=0)
      if axis.kind_of? Quaternion
        subtract!(axis.axis,axis.real)
      elsif axis.point3_like?
        set(@axis-axis,@real-real)
      else
        raise_no_conversion axis
      end
      self
    end
    
    # Returns a new Quaternion instance whose parts are the original
    # instance's multiplied by the given amounts:
    # * axis is a Quaternion, the instance is multiplied by the axis' parts.
    # * axis responds like a Point3, the instance is multiplied by the arguments.
    # * otherwise a TypeError is raised.
    def multiply(axis=origin,real=1)
      quaternion.multiply!(axis,real)
    end
    
    alias * multiply
    
    # Returns the modified instance multiplied by the arguments.
    def multiply!(axis=origin,real=1)
      if axis.kind_of? Quaternion
        multiply!(axis.axis,axis.real)
      elsif axis.point3_like?
        r = (@real*real)-@axis.dot(axis)
        p3 = axis.scale r
        qp3 = @axis.scale real
        cross = @axis.cross axis
        a = p3.add!(qp3).add!(cross)
        set(a,r)
      else
        raise_no_conversion axis
      end
      self
    end
    
    # Returns a new Quaternion instance whose parts are the original
    # instance's multiplied by the scalar:
    # * scalar is a Quaternion, the instance is multiplied by the scalar's parts.
    # * axis is a Numeric, the instance's parts are multiplied by the scalar.
    # * otherwise a TypeError is raised.
    def scale(scalar=1)
      quaternion.scale!(scalar)
    end
    
    # Returns the modified instance multiplied by the scalar.
    def scale!(scalar=1)
      if (scalar.kind_of? Quaternion)
        multiply!(scalar)
      elsif (scalar.kind_of? Numeric)
        set(@axis.scale(scalar),@real*scalar)
      else
        raise_no_conversion scalar, "Numeric"
      end
    end
    
    # Returns a new Quaternion instance that is the conjugate of the original
    # instance.
    def conjugate
      quaternion.conjugate!
    end
    
    # Returns the modified instance replaced with its conjugate.
    def conjugate!
      set(@axis.mirror,@real)
    end
    
    # Returns the norm of the instance.
    def norm
      (@real * @real) + @axis.modulus
    end
    
    # Returns the absolute value of the instance.
    def abs
      Math.sqrt(norm)
    end
    
    # Returns a new Quaternion instance that is the inverse of the original
    # instance.
    def inverse
      quaternion.inverse!
    end
    
    # Returns the modified instance replaced with its inverse.
    def inverse!
      conjugate!
      scale!(1.0/norm)
    end
    
    # Returns a new Quaternion instance whose parts are the original
    # instance's divided by the given amounts:
    # * axis is a Quaternion, the instance is divided by the axis' parts.
    # * axis responds like a Point3, the instance is divided by the arguments.
    # * otherwise a TypeError is raised.
    def divide(axis=origin,real=1)
      quaternion.divide!(axis,origin)
    end
    
    # Returns the modified instance divided by the arguments.
    def divide!(axis=origin,real=1)
      if axis.kind_of? Quaternion
        divide!(axis.axis,axis.real)
      elsif axis.point3_like?
        multiply!(quaternion(axis,real).inverse!)
      else
        raise_no_conversion axis
      end
      self
    end
    
  end
  
end
