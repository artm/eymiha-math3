require 'eymiha/math3'
require 'eymiha/util/envelope'

module Eymiha

  # Envelope3 is the minimum 3D envelope that will completely contain a set of
  # 3D points. 3D cartersian points or other 3D envelopes may be added to an
  # instance, and it can return the number or points considered so far, the
  # x, y and z envelopes, and the high and low Point3 boundaries.
  class Envelope3 < BaseEnvelope
    
    include ThreeDimensions
    
    # 3D cartesian x coordinate envelope reader.
    attr_reader :x
    # 3D cartesian y coordinate envelope reader.
    attr_reader :y
    # 3D cartesian z coordinate envelope reader.
    attr_reader :z
    
    # Creates and returns an instance. If arguments are given, they are passed to
    # the set method to initialize the new instance.
    def initialize(x=nil,y=0,z=0)
      super()
      @x = Envelope.new
      @y = Envelope.new
      @z = Envelope.new
      add(x,y,z) unless x == nil
    end
    
    # Returns a string representation of the instance.
    def to_s
      values = (count > 0)? "\n  high  #{high}\n  low   #{low}" : ""
      "Envelope3: count #{count}#{values}"
    end
    
    # Adds a value to the instance. When
    # * x is an Envelope3, it is coalesced into the instance.
    # * x responds like a Point3, its coordinates are added.
    # * x us Numeric, the arguments are added.
    # * otherwise, an EnvelopeException is raised.
    # The modified instance is returned.
    def add(x=0,y=0,z=0)
      if x.kind_of? Envelope3
        count = x.count
        if count > 0
          add x.high
          add x.low
          @count += (count-2)
        end
        self
      elsif x.point3_like?
        add x.x, x.y, x.z
      elsif x.kind_of? Numeric
        @x.add x
        @y.add y
        @z.add z
        @count += 1
        self
      else
        raise_no_compare x
      end
    end
    
    # Returns a Point3 whose coordinates are the high values of the x, y, and z
    # envelopes.
    # * if there are no boundaries, an EnvelopeException is raised.
    def high
      raise_no_envelope if @count == 0
      (@high ||= Point3.new).set @x.high, @y.high, @z.high
    end
    
    # Returns a Point3 whose coordinates are the low values of the x, y, and z
    # envelopes.
    # * if there are no boundaries, an EnvelopeException is raised.
    def low
      raise_no_envelope if @count == 0
      (@low ||= Point3.new).set @x.low, @y.low, @z.low
    end
    
    # Returns true if the instance completely contains the arguments:
    # * x is an Envelope3, its high and low are contained.
    # * x responds like a Point3, its coordinates are contained.
    # * x is Numeric, the arguments are contained.
    # * otherwise, false is returned.
    def contains?(x=0,y=0,z=0)
      if x.kind_of? Envelope3
        (contains? x.high) && (contains? x.low)
      elsif x.point3_like?
        contains?(x.x,x.y,x.z)
      elsif x.kind_of? Numeric
        (@x.contains? x) && (@y.contains? y) && (@z.contains? z)
      else
        raise_no_compare x
      end
    end
    
  end
  
end
